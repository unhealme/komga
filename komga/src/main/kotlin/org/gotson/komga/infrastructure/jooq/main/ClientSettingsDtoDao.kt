package org.gotson.komga.infrastructure.jooq.main

import org.gotson.komga.interfaces.api.rest.dto.ClientSettingDto
import org.gotson.komga.jooq.main.Tables
import org.jooq.DSLContext
import org.springframework.stereotype.Component

@Component
class ClientSettingsDtoDao(
  val dslContext: DSLContext,
) {
  private val g = Tables.CLIENT_SETTINGS_GLOBAL
  private val u = Tables.CLIENT_SETTINGS_USER

  fun findAllGlobal(onlyUnauthorized: Boolean = false): Map<String, ClientSettingDto> =
    dslContext
      .selectFrom(g)
      .apply { if (onlyUnauthorized) where(g.ALLOW_UNAUTHORIZED.isTrue) }
      .fetch()
      .associate { it.key to ClientSettingDto(it.value, it.allowUnauthorized) }

  fun findAllUser(userId: String): Map<String, ClientSettingDto> =
    dslContext
      .selectFrom(u)
      .where(u.USER_ID.eq(userId))
      .fetch()
      .associate { it.key to ClientSettingDto(it.value, null) }

  fun saveGlobal(
    key: String,
    value: String,
    allowUnauthorized: Boolean,
  ) {
    dslContext
      .insertInto(g, g.KEY, g.VALUE, g.ALLOW_UNAUTHORIZED)
      .values(key, value, allowUnauthorized)
      .onDuplicateKeyUpdate()
      .set(g.VALUE, value)
      .execute()
  }

  fun saveForUser(
    userId: String,
    key: String,
    value: String,
  ) {
    dslContext
      .insertInto(u, u.USER_ID, u.KEY, u.VALUE)
      .values(userId, key, value)
      .onDuplicateKeyUpdate()
      .set(u.VALUE, value)
      .execute()
  }

  fun deleteAll() {
    dslContext.deleteFrom(g).execute()
    dslContext.deleteFrom(u).execute()
  }

  fun deleteGlobalByKeys(keys: Collection<String>) {
    dslContext
      .deleteFrom(g)
      .where(g.KEY.`in`(keys))
      .execute()
  }

  fun deleteByUserIdAndKeys(
    userId: String,
    keys: Collection<String>,
  ) {
    dslContext
      .deleteFrom(u)
      .where(u.KEY.`in`(keys))
      .and(u.USER_ID.eq(userId))
      .execute()
  }

  fun deleteByUserId(userId: String) {
    dslContext
      .deleteFrom(u)
      .where(u.USER_ID.eq(userId))
      .execute()
  }
}
