# CH-001 — screenshot evidence inventory

The image files listed here were captured from the real ClickHouse Cloud SQL Console used for the simulation. Each has been cropped to exclude account identifiers, browser URL, and irrelevant navigation while preserving the query/result area. The two settings views were combined into one **explicitly labelled composite**; no query result was invented.

**Upload status:** Screenshot files are prepared but **not yet present in this GitHub folder**. Do not treat this inventory as image evidence until the PNG files are uploaded.

| Filename | Evidence |
| --- | --- |
| `01-database-discovery.png` | `SHOW DATABASES` confirms accessible databases |
| `02-storage-engine-sharedmergetree.png` | `system.tables` shows engine and sorting key |
| `03-insert-settings.png` | Deduplication/asynchronous insert settings; two scroll positions |
| `03-test-table-created.png` | Isolated reproduction table creation succeeded |
| `04-original-batch-verified.png` | Two original rows read back |
| `05-retry-insert-succeeded.png` | Second identical INSERT received success |
| `06-row-count-unchanged.png` | Row count remained 2 |
| `07-deduplication-part-log.png` | `system.part_log` reports error 389, `INSERT_WAS_DEDUPLICATED` |
| `08-new-batch-verified.png` | Distinct insert resulted in 3 stored rows |

The key screenshots for a hiring-manager review are **02, 03, 06, 07, and 08**. See [the written CH-001 investigation](../cases/CH-001.md) for context and limitations.
