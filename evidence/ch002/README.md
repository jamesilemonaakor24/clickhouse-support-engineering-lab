# CH-002 — Screenshots

These ten screenshots were captured during the ClickHouse Cloud test on 10 November 2026. They are now stored **in this folder**. The images are cropped to focus on queries and their results; no numbers were added or reconstructed.

| Screenshot | What to check |
| --- | --- |
| [01 — Table schema](01-source-table-schema.jpg) | `event_time`, `hostname`, `event_id` and their types |
| [02 — Original query](02-original-query-read.jpg) | Ten results; console reports 581,920 rows read |
| [03 — Original EXPLAIN](03-original-explain-61-61.jpg) | `Condition: true`, `Granules: 61/61` |
| [04 — Original query log](04-baseline-query-log.jpg) | Logged duration, rows read, bytes read and memory |
| [05 — Comparison table](05-optimized-table-created.jpg) | Successful creation with alternative sort order |
| [06 — Record checks](06-data-counts-match.jpg) | 500,000 total and 17 failed-login events in each table |
| [07 — Optimized EXPLAIN](07-optimized-explain-1-61.jpg) | `Condition` on `event_id`, `Granules: 1/61` |
| [08 — Optimized query](08-optimized-query-read.jpg) | Ten results; console reports 16,960 rows read |
| [09 — Optimized query log](09-optimized-query-log.jpg) | Logged resource measurements for optimized query |
| [10 — Result validation](10-results-match.jpg) | `original_rows = 10`, `optimized_rows = 10`, `results_match = 1` |

**How to interpret the evidence:** We observed fewer index granules selected and fewer rows read. The 7 ms and 4 ms times come from one execution each, so this is not a statistically tested latency improvement. The experiment used synthetic data and an isolated comparison table.

[Back to the case report](../../cases/CH-002.md).
