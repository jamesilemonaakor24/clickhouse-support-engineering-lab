# CH-001 — Screenshot evidence

These screenshots come from the personal ClickHouse Cloud lab. The settings image combines two separate scroll positions and is labeled as a composite.

| No. | File | What it supports |
| --- | --- | --- |
| 01 | [01-database-discovery.png](01-database-discovery.png) | Database list includes `support_lab` |
| 02 | [02-storage-engine-sharedmergetree.png](02-storage-engine-sharedmergetree.png) | Original `windows_security_events` table: `SharedMergeTree`, time/host/event sorting key |
| 03 | [03-insert-settings.png](03-insert-settings.png) | Session INSERT settings (composite of two views) |
| 04 | [04-test-table-created.png](04-test-table-created.png) | Disposable `insert_retry_test` table created |
| 05 | [05-original-batch-verified.png](05-original-batch-verified.png) | Two original records returned |
| 06 | [06-retry-insert-succeeded.png](06-retry-insert-succeeded.png) | Identical INSERT acknowledged |
| 07 | [07-row-count-unchanged.png](07-row-count-unchanged.png) | Count remained two |
| 08 | [08-deduplication-part-log.png](08-deduplication-part-log.png) | `system.part_log`: code `389` for duplicate and code `0` for earlier write |
| 09 | [09-new-batch-verified.png](09-new-batch-verified.png) | New batch raised total to three records |
| 10 | [10-clickhouse-version.png](10-clickhouse-version.png) | `SELECT version()` reported `26.6.1.2455` |
| 11 | [11-cloud-azure-region.png](11-cloud-azure-region.png) | Azure Germany West Central shown in service setup |

**Outstanding evidence:** A screenshot of the test table's original zero-row baseline was not captured and cannot be reconstructed by querying the populated table. Screenshots of the original events table's six-row count and column definitions are also missing; these can be checked again. Test-table engine and asynchronous INSERT-log checks remain unperformed.

**Screenshot 08 crop:** The hosted screenshot is the earlier crop with the second result row partly cut off. A corrected crop showing both complete rows has been prepared from the original 10 November 2026 screenshot, but **has not yet replaced this file on GitHub**. No missing pixels were invented.

[Read the CH-001 investigation](../cases/CH-001.md).
