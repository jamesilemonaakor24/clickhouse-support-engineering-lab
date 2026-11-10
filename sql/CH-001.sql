-- CH-001: Identical INSERT retry and deduplication
-- Personal ClickHouse lab only. This is a reference for recreating the documented test,
-- NOT a single script to execute blindly on a customer service.
-- Execute each labeled step separately and inspect the result.
-- A fresh test table is required: if it already exists, stop rather than overwrite it.

-- 1. Discover available databases, tables, and fields.
SHOW DATABASES;
SHOW TABLES FROM support_lab;
DESCRIBE TABLE support_lab.windows_security_events;
SELECT name, engine, sorting_key, partition_key
FROM system.tables
WHERE database = 'support_lab' AND name = 'windows_security_events';

-- 2. Review settings for THIS SQL session only.
SELECT name, value, changed
FROM system.settings
WHERE name IN ('async_insert', 'wait_for_async_insert',
               'insert_deduplicate', 'async_insert_deduplicate')
ORDER BY name;

-- 3. Reproduce in a fresh, disposable table, not a customer table.
CREATE TABLE support_lab.insert_retry_test
(
    batch_id String,
    event_id UInt32,
    message String
)
ENGINE = MergeTree()
ORDER BY (batch_id, event_id);

SELECT count() AS initial_rows FROM support_lab.insert_retry_test;

-- 4. First write: run once.
INSERT INTO support_lab.insert_retry_test
(batch_id, event_id, message)
VALUES
('CH001-BATCH01', 4625, 'Failed login attempt'),
('CH001-BATCH01', 4720, 'User account created');

SELECT * FROM support_lab.insert_retry_test;

-- 5. Identical retry: run the identical INSERT a second time.
-- Observe that this request is acknowledged, then check the count again.
INSERT INTO support_lab.insert_retry_test
(batch_id, event_id, message)
VALUES
('CH001-BATCH01', 4625, 'Failed login attempt'),
('CH001-BATCH01', 4720, 'User account created');

SELECT count() AS total_rows FROM support_lab.insert_retry_test;

-- 6. Check for documented deduplication evidence.
-- A part log is diagnostic evidence, not a substitute for a customer's source reconciliation.
SELECT event_time, event_type, error,
       errorCodeToName(error) AS error_name
FROM system.part_log
WHERE database = 'support_lab'
  AND table = 'insert_retry_test'
ORDER BY event_time DESC
LIMIT 10;

-- 7. Test that a genuinely different batch can still be written.
INSERT INTO support_lab.insert_retry_test
(batch_id, event_id, message)
VALUES ('CH001-BATCH02', 4625, 'New failed login event');

SELECT * FROM support_lab.insert_retry_test ORDER BY batch_id, event_id;

-- 8. Optional cleanup: NOT RUN during the documented investigation.
-- Destructive. Only after saving evidence, and only in your own isolated lab.
-- DROP TABLE IF EXISTS support_lab.insert_retry_test;
