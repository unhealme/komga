package org.gotson.komga.infrastructure.jooq.main

import org.gotson.komga.domain.model.Dimension
import org.gotson.komga.domain.model.ThumbnailSeriesCollection
import org.gotson.komga.domain.persistence.ThumbnailSeriesCollectionRepository
import org.gotson.komga.jooq.main.Tables
import org.gotson.komga.jooq.main.tables.records.ThumbnailCollectionRecord
import org.jooq.DSLContext
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional

@Component
class ThumbnailSeriesCollectionDao(
  val dslContext: DSLContext,
) : ThumbnailSeriesCollectionRepository {
  private val tc = Tables.THUMBNAIL_COLLECTION

  override fun findByIdOrNull(thumbnailId: String): ThumbnailSeriesCollection? =
    dslContext
      .selectFrom(tc)
      .where(tc.ID.eq(thumbnailId))
      .fetchOneInto(tc)
      ?.toDomain()

  override fun findSelectedByCollectionIdOrNull(collectionId: String): ThumbnailSeriesCollection? =
    dslContext
      .selectFrom(tc)
      .where(tc.COLLECTION_ID.eq(collectionId))
      .and(tc.SELECTED.isTrue)
      .limit(1)
      .fetchInto(tc)
      .map { it.toDomain() }
      .firstOrNull()

  override fun findAllByCollectionId(collectionId: String): Collection<ThumbnailSeriesCollection> =
    dslContext
      .selectFrom(tc)
      .where(tc.COLLECTION_ID.eq(collectionId))
      .fetchInto(tc)
      .map { it.toDomain() }

  override fun insert(thumbnail: ThumbnailSeriesCollection) {
    dslContext
      .insertInto(tc)
      .set(tc.ID, thumbnail.id)
      .set(tc.COLLECTION_ID, thumbnail.collectionId)
      .set(tc.THUMBNAIL, thumbnail.thumbnail)
      .set(tc.SELECTED, thumbnail.selected)
      .set(tc.TYPE, thumbnail.type.toString())
      .set(tc.MEDIA_TYPE, thumbnail.mediaType)
      .set(tc.WIDTH, thumbnail.dimension.width)
      .set(tc.HEIGHT, thumbnail.dimension.height)
      .set(tc.FILE_SIZE, thumbnail.fileSize)
      .execute()
  }

  override fun update(thumbnail: ThumbnailSeriesCollection) {
    dslContext
      .update(tc)
      .set(tc.COLLECTION_ID, thumbnail.collectionId)
      .set(tc.THUMBNAIL, thumbnail.thumbnail)
      .set(tc.SELECTED, thumbnail.selected)
      .set(tc.TYPE, thumbnail.type.toString())
      .set(tc.MEDIA_TYPE, thumbnail.mediaType)
      .set(tc.WIDTH, thumbnail.dimension.width)
      .set(tc.HEIGHT, thumbnail.dimension.height)
      .set(tc.FILE_SIZE, thumbnail.fileSize)
      .where(tc.ID.eq(thumbnail.id))
      .execute()
  }

  @Transactional
  override fun markSelected(thumbnail: ThumbnailSeriesCollection) {
    dslContext
      .update(tc)
      .set(tc.SELECTED, false)
      .where(tc.COLLECTION_ID.eq(thumbnail.collectionId))
      .and(tc.ID.ne(thumbnail.id))
      .execute()

    dslContext
      .update(tc)
      .set(tc.SELECTED, true)
      .where(tc.COLLECTION_ID.eq(thumbnail.collectionId))
      .and(tc.ID.eq(thumbnail.id))
      .execute()
  }

  override fun delete(thumbnailCollectionId: String) {
    dslContext.deleteFrom(tc).where(tc.ID.eq(thumbnailCollectionId)).execute()
  }

  override fun deleteByCollectionId(collectionId: String) {
    dslContext.deleteFrom(tc).where(tc.COLLECTION_ID.eq(collectionId)).execute()
  }

  override fun deleteByCollectionIds(collectionIds: Collection<String>) {
    dslContext.deleteFrom(tc).where(tc.COLLECTION_ID.`in`(collectionIds)).execute()
  }

  private fun ThumbnailCollectionRecord.toDomain() =
    ThumbnailSeriesCollection(
      thumbnail = thumbnail,
      selected = selected,
      type = ThumbnailSeriesCollection.Type.valueOf(type),
      mediaType = mediaType,
      fileSize = fileSize,
      dimension = Dimension(width, height),
      id = id,
      collectionId = collectionId,
      createdDate = createdDate,
      lastModifiedDate = lastModifiedDate,
    )
}
