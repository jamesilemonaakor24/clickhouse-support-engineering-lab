# CH-001 — Screenshot evidence

The images currently linked below were captured in a personal ClickHouse Cloud lab. The settings image combines two captured scroll positions.

## Hosted screenshots (01–11)

| No. | File | What it demonstrates |
| --- | --- | --- |
| 01 | [Database discovery](01-database-discovery.png) | `support_lab` listed |
| 02 | [Original table metadata](02-storage-engine-sharedmergetree.png) | `windows_security_events` uses `SharedMergeTree` |
| 03 | [Session INSERT settings](03-insert-settings.png) | SQL Console session settings; two views combined |
| 04 | [Test table created](04-test-table-created.png) | Separate test table created |
| 05 | [Original batch read back](05-original-batch-verified.png) | Two stored records |
| 06 | [Identical retry acknowledged](06-retry-insert-succeeded.png) | INSERT succeeded |
| 07 | [Count unchanged](07-row-count-unchanged.png) | Still two rows |
| 08 | [Part log diagnostic](08-deduplication-part-log.png) | Code 389 on retry, code 0 on original write |
| 09 | [New batch read back](09-new-batch-verified.png) | Three total records |
| 10 | [Version](10-clickhouse-version.png) | ClickHouse version `26.6.1.2455` |
| 11 | [Cloud configuration](11-cloud-azure-region.png) | Azure Germany West Central selected |

## Additional verified screenshots — prepared, not yet hosted

These are **real captures from 10 November 2026**. Their filenames refer to images in the companion screenshot ZIP, not GitHub-hosted links:

| File to upload | Observed result |
| --- | --- |
| `12-original-table-count.jpg` | `SELECT count()` for `windows_security_events` returned **6** |
| `13-original-table-schema.jpg` | Six named columns and types verified |
| `14-retry-test-engine.jpg` | `insert_retry_test` engine reported as **SharedMergeTree** |
| `15-async-insert-status.jpg` | Three matching records; status `Ok`, `data_kind = Parsed`, rows parsed 1, 2, 2 |
| `16-async-insert-flush.jpg` | Additional columns for the same three log records, including flush identifiers |
| `08-deduplication-part-log.png` | **Replacement** showing both complete result rows (0/OK and 389/deduplicated); the existing hosted crop still cuts off the second row |

**Limitation:** The original zero-row count for `insert_retry_test` was not screenshotted. A new count on the already-populated table would not reproduce that historical baseline. The three asynchronous log records were not correlated by full query ID to particular INSERT statements.

The six image files are in the companion evidence ZIP for upload to this `evidence/` directory. Do not upload a nested directory or retain duplicate versions of `08-deduplication-part-log.png`.

[Back to CH-001](../cases/CH-001.md).
