-- CH-002: ClickHouse query efficiency / sorting-key comparison
-- Personal disposable lab only. Never run DDL in a customer account without authorization.
-- Scripts explain the completed experiment; no additional executions are claimed.
-- For a clean rerun, use a fresh database or deliberately clean ONLY your disposable tables.
-- IF NOT EXISTS avoids accidental replacement, but existing data invalidates a fresh baseline.

CREATE DATABASE IF NOT EXISTS support_lab;

-- 1) Generate a synthetic time-sorted event table (500,000 records; 17 event_id = 4625).
CREATE TABLE IF NOT EXISTS support_lab.ch002_events
ENGINE = MergeTree()
ORDER BY (event_time, hostname)
AS
SELECT
    toDateTime('2026-11-01 00:00:00') + number AS event_time,
    concat('WIN-', toString(number % 100)) AS hostname,
    if(number % 30000 = 0, 4625, 4624) AS event_id
FROM numbers(500000);

-- 2) Read-only discovery.
SELECT count() AS total_events FROM support_lab.ch002_events;
DESCRIBE TABLE support_lab.ch002_events;
SELECT name, engine, sorting_key, primary_key, partition_key
FROM system.tables
WHERE database = 'support_lab' AND name = 'ch002_events';

-- 3) Original customer query: 10 output records, far more data considered for reading.
SELECT event_time, hostname, event_id
FROM support_lab.ch002_events
WHERE event_id = 4625
ORDER BY event_time ASC
LIMIT 10;

EXPLAIN indexes = 1
SELECT event_time, hostname, event_id
FROM support_lab.ch002_events
WHERE event_id = 4625
ORDER BY event_time ASC
LIMIT 10;

-- 4) Query-log record for the baseline.
-- system.query_log is populated asynchronously and may be replica-local.
-- Identify the correct execution by timestamp/query_id and actual query text.
SELECT event_time, query_id, query_duration_ms, read_rows, read_bytes,
       result_rows, memory_usage
FROM system.query_log
WHERE type = 'QueryFinish'
  AND query_kind = 'Select'
  AND has(tables, 'support_lab.ch002_events')
  AND position(query, 'event_id = 4625') > 0
  AND position(query, 'LIMIT 10') > 0
ORDER BY event_time DESC
LIMIT 5;

-- 5) Comparison-only table; intentionally changes the row ordering.
CREATE TABLE IF NOT EXISTS support_lab.ch002_events_optimized
ENGINE = MergeTree()
ORDER BY (event_id, event_time, hostname)
AS
SELECT event_time, hostname, event_id
FROM support_lab.ch002_events;

-- 6) Verify aggregate counts, not complete row equivalence.
SELECT 'Original' AS table_name, count() AS total_rows,
       countIf(event_id = 4625) AS failed_logins
FROM support_lab.ch002_events
UNION ALL
SELECT 'Optimized' AS table_name, count() AS total_rows,
       countIf(event_id = 4625) AS failed_logins
FROM support_lab.ch002_events_optimized;

-- 7) Same SELECT against the comparison table.
EXPLAIN indexes = 1
SELECT event_time, hostname, event_id
FROM support_lab.ch002_events_optimized
WHERE event_id = 4625
ORDER BY event_time ASC
LIMIT 10;

SELECT event_time, hostname, event_id
FROM support_lab.ch002_events_optimized
WHERE event_id = 4625
ORDER BY event_time ASC
LIMIT 10;

-- 8) Measure the comparison query; match its own query_id/timestamp.
SELECT event_time, query_id, query_duration_ms, read_rows, read_bytes,
       result_rows, memory_usage
FROM system.query_log
WHERE type = 'QueryFinish'
  AND query_kind = 'Select'
  AND has(tables, 'support_lab.ch002_events_optimized')
  AND position(query, 'event_id = 4625') > 0
  AND position(query, 'LIMIT 10') > 0
ORDER BY event_time DESC
LIMIT 3;

-- 9) Compare exact returned tuples as a multiset; this test has no timestamp ties.
WITH
(
    SELECT groupArray((event_time, hostname, event_id))
    FROM
    (
        SELECT event_time, hostname, event_id
        FROM support_lab.ch002_events
        WHERE event_id = 4625
        ORDER BY event_time ASC
        LIMIT 10
    )
) AS original_results,
(
    SELECT groupArray((event_time, hostname, event_id))
    FROM
    (
        SELECT event_time, hostname, event_id
        FROM support_lab.ch002_events_optimized
        WHERE event_id = 4625
        ORDER BY event_time ASC
        LIMIT 10
    )
) AS optimized_results
SELECT length(original_results) AS original_rows,
       length(optimized_results) AS optimized_rows,
       arraySort(original_results) = arraySort(optimized_results) AS results_match;

-- Optional DESTRUCTIVE CLEANUP: not executed in the documented experiment.
-- Only after preserving evidence, with approval, in YOUR disposable lab.
-- DROP TABLE IF EXISTS support_lab.ch002_events_optimized;
-- DROP TABLE IF EXISTS support_lab.ch002_events;
