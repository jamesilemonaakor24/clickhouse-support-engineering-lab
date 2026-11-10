# CH-002 — Evidence register

**Status:** The ten cropped screenshots are prepared, but **they have not been uploaded to this GitHub folder**. The filenames below describe the files in the separately provided CH-002 evidence ZIP, not links to currently hosted GitHub images. Do not treat the inventory as proof that a screenshot is online.

The crops exclude the browser URL, account sidebar, and unrelated navigation. They preserve the SQL console query/results portions. These are crops of the original session, not generated mockups.

| Prepared filename | What it shows |
| --- | --- |
| `01-source-table-schema.jpg` | Three-column schema for the generated dataset |
| `02-original-query-read.jpg` | Baseline query and console read statistics |
| `03-original-explain-61-61.jpg` | Original EXPLAIN selecting 61/61 granules |
| `04-baseline-query-log.jpg` | Baseline rows/bytes/time/memory from the query log |
| `05-optimized-table-created.jpg` | Separate sorted comparison table creation |
| `06-data-counts-match.jpg` | Both tables contain 500,000 rows and 17 failed-login events |
| `07-optimized-explain-1-61.jpg` | Optimized primary key selecting 1/61 granules |
| `08-optimized-query-read.jpg` | Optimized query and console read statistics |
| `09-optimized-query-log.jpg` | Optimized rows/bytes/time/memory from the query log |
| `10-results-match.jpg` | Exact ten-tuple multiset comparison returns `results_match = 1` |

The full evidence chain and limitations are documented in [CH-002](../../cases/CH-002.md). In particular, the **7 ms / 4 ms figures are single-run measurements**, not a rigorous latency benchmark. Original data are synthetic. Screenshot evidence should be uploaded only after inspecting the crops for accuracy and confidentiality.

When uploading these files, put them **directly inside `evidence/ch002/`**, not in a second nested `evidence/` folder.
