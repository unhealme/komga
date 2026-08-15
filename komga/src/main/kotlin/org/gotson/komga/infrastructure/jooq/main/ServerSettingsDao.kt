package org.gotson.komga.infrastructure.jooq.main

import org.gotson.komga.jooq.main.Tables
import org.jooq.DSLContext
import org.springframework.stereotype.Component

@Component
class ServerSettingsDao(
  val dslContext: DSLContext,
) {
  private val s = Tables.SERVER_SETTINGS

  fun <T> getSettingByKey(
    key: String,
    clazz: Class<T>,
  ): T? =
    dslContext
      .select(s.VALUE)
      .from(s)
      .where(s.KEY.eq(key))
      .fetchOneInto(clazz)

  fun saveSetting(
    key: String,
    value: String,
  ) {
    dslContext
      .insertInto(s)
      .values(key, value)
      .onDuplicateKeyUpdate()
      .set(s.VALUE, value)
      .execute()
  }

  fun saveSetting(
    key: String,
    value: Boolean,
  ) {
    saveSetting(key, value.toString())
  }

  fun saveSetting(
    key: String,
    value: Int,
  ) {
    saveSetting(key, value.toString())
  }

  fun deleteSetting(key: String) {
    dslContext.deleteFrom(s).where(s.KEY.eq(key)).execute()
  }

  fun deleteAll() {
    dslContext.deleteFrom(s).execute()
  }
}
