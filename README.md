# ClickHouse Support Engineering Lab

**Hands-on ClickHouse Cloud troubleshooting, documented as simulated customer support cases.**

This portfolio focuses on a support engineer's workflow: **acknowledge → scope → discover → diagnose → validate → communicate → assess escalation**. It is not a collection of SQL examples presented as production support experience.

## Environment

- **Platform:** ClickHouse Cloud on Microsoft Azure (Germany West Central), confirmed from the provisioning settings shown during setup
- **Database version observed:** `26.6.1.2455` (`SELECT version()`); original console evidence available
- **Storage engine observed:** `SharedMergeTree` on the originally inspected `windows_security_events` table; the separate reproduction table's engine has not been independently checked
- **Dataset:** Small, wholly synthetic Windows-style security events
- **Access:** Personal lab environment; no actual customer data, systems, tickets or ClickHouse internal tools

## Investigations

| Case | Reported symptom (simulated) | Verified lab outcome | Status |
| --- | --- | --- | --- |
| **CH-001** | An identical retry of a successful INSERT does not increase the row count | Initial 0 → first insert 2 → identical retry 2 → distinct insert 3; `system.part_log` reported `INSERT_WAS_DEDUPLICATED` (389) | Reproduction and diagnosis complete; customer confirmation simulated, not obtained |
 
**[Read the full CH-001 investigation](cases/CH-001.md)** — discovery, SQL diagnostics, reproduced evidence, explanation, customer-facing update, limitations and escalation criteria.

## Skills demonstrated

- Discovering unfamiliar databases, tables, schemas and table engine metadata before querying
- Checking asynchronous INSERT and deduplication settings without assuming those settings apply to the customer's application
- Reproducing a reported symptom safely in an isolated test table
- Correlating table row counts with diagnostics in `system.part_log`
- Explaining expected ClickHouse behavior without confusing a successful retry with a new write
- Writing an evidence-based customer response and documenting when to escalate

## Evidence and transparency

Results in the case report were observed in my own ClickHouse Cloud lab. The **customer complaint and communication are fictional support simulations**, inspired by a publicly documented ClickHouse issue. No actual customer support case, production outage, or engineering escalation occurred.

All 11 cropped screenshots have been uploaded to the [evidence folder](evidence/) and linked from the [CH-001 case report](cases/CH-001.md). The captures show observed SQL outputs, with unrelated browser/account UI removed.

**Reference:** [ClickHouse engineering: Getting started with ClickHouse? 13 mistakes and how to avoid them](https://clickhouse.com/blog/common-getting-started-issues-with-clickhouse).

## Planned extension

CH-002: a safety-focused investigation of the `Too many parts` ingestion failure pattern, using documented mechanisms and read-only diagnostics. An actual error reproduction will only be claimed if observed.

---
*Independent learning portfolio. Not affiliated with ClickHouse, its customers, or any real bank.*
