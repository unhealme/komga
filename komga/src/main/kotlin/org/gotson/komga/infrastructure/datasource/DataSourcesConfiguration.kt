package org.gotson.komga.infrastructure.datasource

import com.zaxxer.hikari.HikariConfig
import com.zaxxer.hikari.HikariDataSource
import org.gotson.komga.infrastructure.configuration.KomgaProperties
import org.postgresql.ds.PGSimpleDataSource
import org.springframework.boot.jdbc.DataSourceBuilder
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Primary
import javax.sql.DataSource
import kotlin.time.Duration.Companion.minutes

@Configuration
class DataSourcesConfiguration(
  private val komgaProperties: KomgaProperties,
) {
  @Bean("mainDataSource")
  @Primary
  fun mainDataSource() = buildDataSource("MainPool", Runtime.getRuntime().availableProcessors().coerceIn(2, komgaProperties.database.maxPoolSize))

  @Bean("tasksDataSource")
  fun tasksDataSource() = buildDataSource("TasksPool", 1)

  private fun buildDataSource(poolName: String, maxSize: Int): DataSource {
    val dataSource =
      DataSourceBuilder
        .create()
        .driverClassName("org.postgresql.Driver")
        .url(komgaProperties.database.url)
        .type(PGSimpleDataSource::class.java)
        .build()

    return HikariDataSource(
      HikariConfig().apply {
        this.dataSource = dataSource
        this.poolName = poolName
        this.maximumPoolSize = maxSize
        if (maxSize > 1) {
          this.minimumIdle = 2
          this.idleTimeout = 5.minutes.inWholeMilliseconds
          this.maxLifetime = 15.minutes.inWholeMilliseconds
          this.leakDetectionThreshold = 1.minutes.inWholeMilliseconds
        }
        addDataSourceProperty("cachePrepStmts", "true")
        addDataSourceProperty("useServerPrepStmts", "true")
      },
    )
  }
}
