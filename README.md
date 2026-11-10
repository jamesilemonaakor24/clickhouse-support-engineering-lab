# ClickHouse Support Engineering — Troubleshooting Cases

Two hands-on ClickHouse Cloud investigations, written as support case notes: clarify the report, inspect the service, test a hypothesis without changing the source table, verify the outcome, and explain the next action to the customer.

**These are simulations.** I ran the SQL and collected the metrics in my own ClickHouse Cloud environment; the customer messages and support responses are fictional. No customer production access or incident ownership is claimed.

## Case files

| Case | What I investigated | Evidence and outcome |
| --- | --- | --- |
| [CH-001 — INSERT retries without additional rows](cases/CH-001.md) | Does a successful retry imply new data was stored? | Reproduced a duplicate batch; `system.part_log` recorded `INSERT_WAS_DEDUPLICATED` (389). Distinct new data still inserted. [Screenshots](evidence/README.md) |
| [CH-002 — `LIMIT 10` reads too much data](cases/CH-002.md) | Why does an event-filtered query read far more than ten rows? | `EXPLAIN` showed 61/61 granules selected. A separate table ordered by event type first selected 1/61 granules and read **97.1% fewer rows**, returning the same ten events. [Reproduction SQL](sql/CH-002.sql) · [Screenshots](evidence/ch002/README.md) |

### CH-002 — what changed

The test dataset had **500,000 synthetic events**. The source table was sorted by time: `(event_time, hostname)`. But the query searched by event type (`WHERE event_id = 4625`). We tested the same data in a separate table sorted by `(event_id, event_time, hostname)`, so ClickHouse could find the matching records with less reading.

| Measured field | Original | Comparison |
| --- | ---: | ---: |
| Granules selected | 61/61 | **1/61** |
| Rows read | 581,920 | **16,960** |
| Bytes read | 3,498,552 | **194,183** |
| Memory reported | 13,946,595 | **6,983,493** |
| Duration, one execution | 7 ms | 4 ms |
| Result tuples | 10 | 10, independently matched |

**What this means:** the tested query did much less reading. Both queries were already fast; a single 7 ms versus 4 ms observation does **not** establish a production latency improvement. Changing a sort key could hurt other workloads, so this is a comparison, not an unconditional production recommendation.

## Working environment and approach

- ClickHouse Cloud on **Microsoft Azure (Germany West Central)**, in a personal trial environment.
- The session reported ClickHouse version `26.6.1.2455`.
- The tables investigated used ClickHouse Cloud's MergeTree family; `SharedMergeTree` was observed in `system.tables` on the original CH-001 table and CH-002 source table.
- Data are synthetic Windows-style event records. Event ID 4625 represents failed logons; it is an event *type*, not a unique event identifier.

The investigations use `DESCRIBE TABLE`, `system.tables`, `EXPLAIN indexes = 1`, `system.query_log`, `system.part_log`, controlled test tables, and read-back validation. Each case distinguishes observed data, a supported interpretation, and what still requires customer-side evidence.

## Reproduce or review

Start with the [CH-002 case](cases/CH-002.md) for the problem statement, results, customer response, and decision-making. The [SQL script](sql/CH-002.sql) is commented and designed for a disposable lab; review any DDL before running. **All ten CH-002 screenshots are uploaded** to the [CH-002 evidence folder](evidence/ch002/) and indexed in its [evidence guide](evidence/ch002/README.md). The [CH-001 screenshots](evidence/) and [CH-001 reproduction SQL](sql/CH-001.sql) are also available.

These tests are not proof of production database administration or support-queue experience. They also do not test high traffic, system outages, or repeat-run performance.

## What I'd do with a real ticket

I'd first ask what is affected and how seriously, then request the query and relevant logs without collecting sensitive customer data. I'd inspect the existing setup before changing anything and test a proposed fix separately. Before any production change, I'd check its impact on other queries and prepare a rollback plan. I'd keep the customer informed and escalate with clear evidence if needed.

---

Independent learning portfolio; not affiliated with ClickHouse or its customers.
