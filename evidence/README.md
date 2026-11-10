# CH-001 — Screenshot evidence inventory

These images were captured from the real ClickHouse Cloud SQL Console used for a **synthetic support simulation**. Images have been cropped to exclude personal/browser navigation information and preserve query/results. The settings image is a **clearly labeled composite of two separate scroll positions**, not a single original screen.

**Upload status:** All 11 screenshots are uploaded to this evidence folder. The filename references below correspond to actual PNG files.

| Filename | Observation supported |
| --- | --- |
| [01-database-discovery.png](01-database-discovery.png) | `SHOW DATABASES` lists the available databases |
| [02-storage-engine-sharedmergetree.png](02-storage-engine-sharedmergetree.png) | `system.tables` reports **`windows_security_events`** as `SharedMergeTree`, sorting key `event_time, hostname, event_id`; this is **not** a test-table engine verification |
| [03-insert-settings.png](03-insert-settings.png) | Four SQL-session settings from two separately captured scroll positions; values and `changed` flags |
| [03-test-table-created.png](03-test-table-created.png) | Isolated `insert_retry_test` table creation succeeded |
| [04-original-batch-verified.png](04-original-batch-verified.png) | Two original test records read back |
| [05-retry-insert-succeeded.png](05-retry-insert-succeeded.png) | Repeated identical INSERT was acknowledged |
| [06-row-count-unchanged.png](06-row-count-unchanged.png) | Count stayed at 2 |
| [07-deduplication-part-log.png](07-deduplication-part-log.png) | `system.part_log` code 389; the full error-name text is clipped by the console view. `errorCodeToName(error)` was executed and the code is the decisive reproducible indicator |
| [08-new-batch-verified.png](08-new-batch-verified.png) | Distinct INSERT resulted in 3 rows |
| [09-clickhouse-version.png](09-clickhouse-version.png) | `SELECT version()` returned `26.6.1.2455` |
| [10-cloud-azure-region.png](10-cloud-azure-region.png) | Service setup selected Azure Germany West Central |

For interview review, prioritize **02, 03, 06, 07, and 08**, alongside the written [CH-001 case](../cases/CH-001.md). **No screenshot establishes that `insert_retry_test` used `SharedMergeTree`, or that the INSERT traversed an async buffer.** Those checks are pending.
