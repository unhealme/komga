package org.gotson.komga.infrastructure.jooq.main

import org.gotson.komga.domain.model.AgeRestriction
import org.gotson.komga.domain.model.AllowExclude
import org.gotson.komga.domain.model.ApiKey
import org.gotson.komga.domain.model.ContentRestrictions
import org.gotson.komga.domain.model.KomgaUser
import org.gotson.komga.domain.model.UserRoles
import org.gotson.komga.domain.persistence.KomgaUserRepository
import org.gotson.komga.jooq.main.Tables
import org.gotson.komga.jooq.main.tables.records.UserApiKeyRecord
import org.gotson.komga.language.toCurrentTimeZone
import org.jooq.DSLContext
import org.jooq.Record
import org.jooq.ResultQuery
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDateTime
import java.time.ZoneId

@Component
class KomgaUserDao(
  val dslContext: DSLContext,
) : KomgaUserRepository {
  private val u = Tables.USER
  private val ur = Tables.USER_ROLE
  private val ul = Tables.USER_LIBRARY_SHARING
  private val us = Tables.USER_SHARING
  private val ar = Tables.ANNOUNCEMENTS_READ
  private val uak = Tables.USER_API_KEY

  override fun count(): Long = dslContext.fetchCount(u).toLong()

  override fun findAll(): Collection<KomgaUser> =
    dslContext
      .selectBase()
      .fetchAndMap(dslContext)

  override fun findApiKeyByUserId(userId: String): Collection<ApiKey> =
    dslContext
      .selectFrom(uak)
      .where(uak.USER_ID.eq(userId))
      .fetchInto(uak)
      .map {
        it.toDomain()
      }

  override fun findByIdOrNull(id: String): KomgaUser? =
    dslContext
      .selectBase()
      .where(u.ID.equal(id))
      .fetchAndMap(dslContext)
      .firstOrNull()

  private fun DSLContext.selectBase() =
    select(*u.fields())
      .select(ul.LIBRARY_ID)
      .from(u)
      .leftJoin(ul)
      .onKey()

  private fun ResultQuery<Record>.fetchAndMap(dsl: DSLContext) =
    this
      .fetchGroups({ it.into(u) }, { it.into(ul) })
      .map { (userRecord, ulr) ->
        val usr =
          dsl
            .selectFrom(us)
            .where(us.USER_ID.eq(userRecord.id))
            .toList()
        val roles =
          dsl
            .select(ur.ROLE)
            .from(ur)
            .where(ur.USER_ID.eq(userRecord.id))
            .fetch(ur.ROLE)
        KomgaUser(
          email = userRecord.email,
          password = userRecord.password,
          roles = UserRoles.valuesOf(roles),
          sharedLibrariesIds = ulr.mapNotNull { it.libraryId }.toSet(),
          sharedAllLibraries = userRecord.sharedAllLibraries,
          restrictions =
            ContentRestrictions(
              ageRestriction =
                if (userRecord.ageRestriction != null && userRecord.ageRestrictionAllowOnly != null)
                  AgeRestriction(userRecord.ageRestriction, if (userRecord.ageRestrictionAllowOnly) AllowExclude.ALLOW_ONLY else AllowExclude.EXCLUDE)
                else
                  null,
              labelsAllow = usr.filter { it.allow }.map { it.label }.toSet(),
              labelsExclude = usr.filterNot { it.allow }.map { it.label }.toSet(),
            ),
          id = userRecord.id,
          createdDate = userRecord.createdDate.toCurrentTimeZone(),
          lastModifiedDate = userRecord.lastModifiedDate.toCurrentTimeZone(),
        )
      }

  @Transactional
  override fun insert(user: KomgaUser) {
    dslContext
      .insertInto(u)
      .set(u.ID, user.id)
      .set(u.EMAIL, user.email)
      .set(u.PASSWORD, user.password)
      .set(u.SHARED_ALL_LIBRARIES, user.sharedAllLibraries)
      .set(u.AGE_RESTRICTION, user.restrictions.ageRestriction?.age)
      .set(
        u.AGE_RESTRICTION_ALLOW_ONLY,
        when (user.restrictions.ageRestriction?.restriction) {
          AllowExclude.ALLOW_ONLY -> true
          AllowExclude.EXCLUDE -> false
          null -> null
        },
      ).execute()

    dslContext.insertRoles(user)
    dslContext.insertSharedLibraries(user)
    dslContext.insertSharingRestrictions(user)
  }

  override fun insert(apiKey: ApiKey) {
    dslContext
      .insertInto(uak)
      .set(uak.ID, apiKey.id)
      .set(uak.USER_ID, apiKey.userId)
      .set(uak.API_KEY, apiKey.key)
      .set(uak.COMMENT, apiKey.comment)
      .execute()
  }

  @Transactional
  override fun update(user: KomgaUser) {
    dslContext
      .update(u)
      .set(u.EMAIL, user.email)
      .set(u.PASSWORD, user.password)
      .set(u.SHARED_ALL_LIBRARIES, user.sharedAllLibraries)
      .set(u.AGE_RESTRICTION, user.restrictions.ageRestriction?.age)
      .set(
        u.AGE_RESTRICTION_ALLOW_ONLY,
        when (user.restrictions.ageRestriction?.restriction) {
          AllowExclude.ALLOW_ONLY -> true
          AllowExclude.EXCLUDE -> false
          null -> null
        },
      ).set(u.LAST_MODIFIED_DATE, LocalDateTime.now(ZoneId.of("Z")))
      .where(u.ID.eq(user.id))
      .execute()

    dslContext
      .deleteFrom(ur)
      .where(ur.USER_ID.eq(user.id))
      .execute()

    dslContext
      .deleteFrom(ul)
      .where(ul.USER_ID.eq(user.id))
      .execute()

    dslContext
      .deleteFrom(us)
      .where(us.USER_ID.eq(user.id))
      .execute()

    dslContext.insertRoles(user)
    dslContext.insertSharedLibraries(user)
    dslContext.insertSharingRestrictions(user)
  }

  override fun saveAnnouncementIdsRead(
    user: KomgaUser,
    announcementIds: Set<String>,
  ) {
    dslContext
      .batch(
        announcementIds.map {
          dslContext.insertInto(ar).values(user.id, it).onDuplicateKeyIgnore()
        },
      ).execute()
  }

  private fun DSLContext.insertRoles(user: KomgaUser) {
    user.roles.forEach {
      this
        .insertInto(ur)
        .columns(ur.USER_ID, ur.ROLE)
        .values(user.id, it.name)
        .execute()
    }
  }

  private fun DSLContext.insertSharedLibraries(user: KomgaUser) {
    user.sharedLibrariesIds.forEach {
      this
        .insertInto(ul)
        .columns(ul.USER_ID, ul.LIBRARY_ID)
        .values(user.id, it)
        .execute()
    }
  }

  private fun DSLContext.insertSharingRestrictions(user: KomgaUser) {
    user.restrictions.labelsAllow.forEach { label ->
      this
        .insertInto(us)
        .columns(us.USER_ID, us.ALLOW, us.LABEL)
        .values(user.id, true, label)
        .execute()
    }

    user.restrictions.labelsExclude.forEach { label ->
      this
        .insertInto(us)
        .columns(us.USER_ID, us.ALLOW, us.LABEL)
        .values(user.id, false, label)
        .execute()
    }
  }

  @Transactional
  override fun delete(userId: String) {
    dslContext.deleteFrom(uak).where(uak.USER_ID.equal(userId)).execute()
    dslContext.deleteFrom(ar).where(ar.USER_ID.equal(userId)).execute()
    dslContext.deleteFrom(us).where(us.USER_ID.equal(userId)).execute()
    dslContext.deleteFrom(ul).where(ul.USER_ID.equal(userId)).execute()
    dslContext.deleteFrom(ur).where(ur.USER_ID.equal(userId)).execute()
    dslContext.deleteFrom(u).where(u.ID.equal(userId)).execute()
  }

  @Transactional
  override fun deleteAll() {
    dslContext.deleteFrom(uak).execute()
    dslContext.deleteFrom(ar).execute()
    dslContext.deleteFrom(us).execute()
    dslContext.deleteFrom(ul).execute()
    dslContext.deleteFrom(ur).execute()
    dslContext.deleteFrom(u).execute()
  }

  override fun deleteApiKeyByIdAndUserId(
    apiKeyId: String,
    userId: String,
  ) {
    dslContext
      .deleteFrom(uak)
      .where(uak.ID.eq(apiKeyId))
      .and(uak.USER_ID.eq(userId))
      .execute()
  }

  override fun deleteApiKeyByUserId(userId: String) {
    dslContext.deleteFrom(uak).where(uak.USER_ID.eq(userId)).execute()
  }

  override fun findAnnouncementIdsReadByUserId(userId: String): Set<String> =
    dslContext
      .select(ar.ANNOUNCEMENT_ID)
      .from(ar)
      .where(ar.USER_ID.eq(userId))
      .fetchSet(ar.ANNOUNCEMENT_ID)

  override fun existsByEmailIgnoreCase(email: String): Boolean =
    dslContext.fetchExists(
      dslContext
        .selectFrom(u)
        .where(u.EMAIL.equalIgnoreCase(email)),
    )

  override fun existsApiKeyByIdAndUserId(
    apiKeyId: String,
    userId: String,
  ): Boolean = dslContext.fetchExists(uak, uak.ID.eq(apiKeyId).and(uak.USER_ID.eq(userId)))

  override fun existsApiKeyByCommentAndUserId(
    comment: String,
    userId: String,
  ): Boolean = dslContext.fetchExists(uak, uak.COMMENT.equalIgnoreCase(comment).and(uak.USER_ID.eq(userId)))

  override fun findByEmailIgnoreCaseOrNull(email: String): KomgaUser? =
    dslContext
      .selectBase()
      .where(u.EMAIL.equalIgnoreCase(email))
      .fetchAndMap(dslContext)
      .firstOrNull()

  override fun findByApiKeyOrNull(apiKey: String): Pair<KomgaUser, ApiKey>? {
    val user =
      dslContext
        .selectBase()
        .leftJoin(uak)
        .on(u.ID.eq(uak.USER_ID))
        .where(uak.API_KEY.eq(apiKey))
        .fetchAndMap(dslContext)
        .firstOrNull() ?: return null

    val key =
      dslContext
        .selectFrom(uak)
        .where(uak.API_KEY.eq(apiKey))
        .fetchInto(uak)
        .map { it.toDomain() }
        .firstOrNull() ?: return null

    return Pair(user, key)
  }

  private fun UserApiKeyRecord.toDomain() =
    ApiKey(
      id = id,
      userId = userId,
      key = apiKey,
      comment = comment,
      createdDate = createdDate.toCurrentTimeZone(),
      lastModifiedDate = lastModifiedDate.toCurrentTimeZone(),
    )
}
