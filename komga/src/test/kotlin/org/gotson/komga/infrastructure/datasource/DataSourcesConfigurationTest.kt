package org.gotson.komga.infrastructure.datasource

import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.boot.test.context.SpringBootTest
import javax.sql.DataSource

class DataSourcesConfigurationTest {
  @SpringBootTest
  @Nested
  inner class WalMode(
    @Autowired private val mainDataSource: DataSource,
    @Autowired @Qualifier("tasksDataSource") private val tasksDataSource: DataSource,
  ) {
    @Test
    fun `given wal mode when autoriwiring beans then bean instances are different between RW and RO`() {
      assertThat(mainDataSource).isNotSameAs(tasksDataSource)
    }
  }
}
