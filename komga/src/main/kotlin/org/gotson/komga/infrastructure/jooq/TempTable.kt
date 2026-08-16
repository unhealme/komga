package org.gotson.komga.infrastructure.jooq

import com.github.f4b6a3.tsid.TsidCreator
import org.jooq.DSLContext
import org.jooq.Name
import org.jooq.impl.DSL
import org.jooq.impl.SQLDataType.VARCHAR
import java.io.Closeable
import java.util.concurrent.atomic.AtomicBoolean

/**
 * Temporary table with a single STRING column.
 * This is made to store collection of values that are too long to be specified in a query condition,
 * by using a sub-select instead.
 *
 * The table name is automatically generated, and the table is dropped when the object is closed.
 */
class TempTable private constructor(
  private val dslContext: DSLContext,
  private val name: Name,
) : Closeable {
  constructor(dslContext: DSLContext) : this(dslContext, generateName())

  private val created = AtomicBoolean(false)

  fun create() {
    if (!created.get()) {
      dslContext.createTemporaryTable(name).column(DSL.name("STRING"), VARCHAR.notNull()).execute()
      created.set(true)
    }
  }

  fun insertTempStrings(
    batchSize: Int,
    collection: Collection<String>,
  ) {
    create()
    if (collection.isNotEmpty()) {
      collection.chunked(batchSize).forEach { chunk ->
        dslContext
          .batch(
            dslContext.insertInto(DSL.table(name), DSL.field(DSL.name("STRING"), String::class.java)).values(null as String?),
          ).also { step ->
            chunk.forEach {
              step.bind(it)
            }
          }.execute()
      }
    }
  }

  fun selectTempStrings() = dslContext.select(DSL.field(DSL.name("STRING"), String::class.java)).from(name)

  override fun close() {
    if (created.get()) {
      dslContext.dropTableIfExists(name).execute()
      created.set(false)
    }
  }

  companion object {
    private fun generateName() = DSL.name("temp_${TsidCreator.getTsid256()}")

    fun <R> DSLContext.withTempTable(
      batchSize: Int,
      collection: Collection<String>,
      block: (TempTable, DSLContext) -> R,
    ): R {
      return this.transactionResult { config ->
        val ctx = config.dsl()
        val tt = TempTable(ctx, generateName())
        tt.use {
          it.insertTempStrings(batchSize, collection)
          block(it, ctx)
        }
      }
    }
  }
}
