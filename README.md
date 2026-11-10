# ClickHouse Support Engineering — Troubleshooting Cases

Two hands-on ClickHouse Cloud investigations, written as support case notes: clarify the report, inspect the service, test a hypothesis without changing the source table, verify the outcome, and explain the next action to the customer.

**These are simulations.** I ran the SQL and collected the metrics in my own ClickHouse Cloud environment; the customer messages and support responses are fictional. No customer production access or incident ownership is claimed.

## Case files

| Case | What I investigated | Evidence and outcome |
| --- | --- | --- |
| [CH-001 — INSERT retries without additional rows](cases/CH-001.md) | Does a successful retry imply new data was stored? | Reproduced a duplicate batch; `system.part_log` recorded `INSERT_WAS_DEDUPLICATED` (389). Distinct new data still inserted. [Screenshots](evidence/README.md) |
| [CH-002 — `LIMIT 10` reads too much data](cases/CH-002.md) | Why does an event-filtered query read far more than ten rows? | `EXPLAIN` showed 61/61 granules selected. A separate table ordered by event type first selected 1/61 granules and read **97.1% fewer rows**, returning the same ten events. [Reproduction SQL](sql/CH-002.sql) · [Evidence register](evidence/ch002/README.md) |

### CH-002 in 30 seconds

The test dataset had **500,000 synthetic events**. The original sort key, `(event_time, hostname)`, did not let ClickHouse prune granules for `WHERE event_id = 4625`. A separately created comparison table, ordered by `(event_id, event_time, hostname)`, changed that.

| Measured field | Original | Comparison |
| --- | ---: | ---: |
| Granules selected | 61/61 | **1/61** |
| Rows read | 581,920 | **16,960** |
| Bytes read | 3,498,552 | **194,183** |
| Memory reported | 13,946,595 | **6,983,493** |
| Duration, one execution | 7 ms | 4 ms |
| Result tuples | 10 | 10, independently matched |

**Interpretation:** meaningful reduction in work performed by this one query. Both queries were already fast; a single 7 ms versus 4 ms observation does **not** establish a production latency improvement. Changing a sort key could hurt other workloads, so this is a comparison, not an unconditional production recommendation.

## Working environment and approach

- ClickHouse Cloud on **Microsoft Azure (Germany West Central)**, in a personal trial environment.
- The session reported ClickHouse version `26.6.1.2455`.
- The tables investigated used ClickHouse Cloud's MergeTree family; `SharedMergeTree` was observed in `system.tables` on the original CH-001 table and CH-002 source table.
- Data are synthetic Windows-style event records. Event ID 4625 represents failed logons; it is an event *type*, not a unique event identifier.

The investigations use `DESCRIBE TABLE`, `system.tables`, `EXPLAIN indexes = 1`, `system.query_log`, `system.part_log`, controlled test tables, and read-back validation. Each case distinguishes observed data, a supported interpretation, and what still requires customer-side evidence.

## Reproduce or review

Start with the [CH-002 case](cases/CH-002.md) for the problem statement, results, customer response, and decision-making. The [SQL script](sql/CH-002.sql) is commented and designed for a disposable lab; review any DDL before running. **CH-002 screenshots are prepared but not yet uploaded to GitHub**; the [register](evidence/ch002/README.md) states exactly which captures exist. All [CH-001 screenshots](evidence/) are hosted.

The work does **not** establish production DBA/SRE experience, workload-wide optimization, a network outage simulation, or real ClickHouse support tickets. I haven't tested query performance under concurrent load or measured repeat-run latency distributions.

## What I'd do with a real ticket

Start with impact and affected query IDs, confirm the customer has authorized inspection, and collect sanitized SQL and representative workload patterns. Prefer read-only diagnostics and a separate controlled test. Propose a production change only after reviewing competing query patterns, ingestion rate, downtime/migration risks, and rollback. Keep the customer informed with findings and uncertainty; escalate with clear reproduction steps and correlated logs if the results contradict expected behavior.

---

Independent learning portfolio; not affiliated with ClickHouse or its customers.
