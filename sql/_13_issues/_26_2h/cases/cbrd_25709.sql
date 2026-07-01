/**
 * This test case verifies CBRD-25709: Trigger DEFERRED recursion must be
 * stopped by maximum trigger depth instead of looping forever.
 *
 * Coverage:
 * 1. Main repro - DEFERRED INSERT trigger recurses into itself.
 * 2. DEFERRED trigger inserts into a different table.
 * 3. BEFORE trigger recursion still raises trigger depth.
 * 4. AFTER trigger recursion still raises trigger depth.
 * 5. Indirect cross-trigger DEFERRED cycle.
 * 6. Bounded DEFERRED recursion stops before max depth.
 * 7. Bounded DEFERRED recursion exceeding max depth is stopped.
 * 8. ROLLBACK before COMMIT means DEFERRED action never fires.
 * 9. DEFERRED UPDATE trigger recurses into itself.
 * 10. Mixed-event DEFERRED cycle.
 */

--+ server-message on

-- SETUP: Create Test Tables
DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
DROP TABLE IF EXISTS t3;
 
CREATE TABLE t1(col1 int, col2 int);
CREATE TABLE t2(col1 int, col2 int);
 
evaluate 'Case 1. Main repro - DEFERRED trigger recurses into itself';
CREATE TRIGGER tr1
DEFERRED INSERT ON t1
EXECUTE INSERT INTO t1 VALUES (1, 2);
 
INSERT INTO t1 VALUES (1, 1);
-- Expected: ERROR - Maximum trigger depth 32 exceeded at trigger "dba.tr1"
 
DROP TRIGGER tr1;
DELETE FROM t1;
 
evaluate 'Case 2. DEFERRED trigger inserts into a different table (no recursion)';
CREATE TRIGGER tr1
DEFERRED INSERT ON t1
EXECUTE INSERT INTO t2 VALUES (1, 2);
 
INSERT INTO t1 VALUES (1, 1);
SELECT col1, col2 FROM t2;
-- Expected: succeeds normally; t2 contains one row (1, 2)
 
DROP TRIGGER tr1;
DELETE FROM t1;
DELETE FROM t2;
 
evaluate 'Case 3. BEFORE trigger recursion still raises Maximum trigger depth';
CREATE TRIGGER tr1
BEFORE INSERT ON t1
EXECUTE INSERT INTO t1 VALUES (1, 2);
 
INSERT INTO t1 VALUES (1, 1);
-- Expected: ERROR - Maximum trigger depth 32 exceeded at trigger "dba.tr1"
 
DROP TRIGGER tr1;
DELETE FROM t1;
 
evaluate 'Case 4. AFTER trigger recursion still raises Maximum trigger depth';
CREATE TRIGGER tr1
AFTER INSERT ON t1
EXECUTE INSERT INTO t1 VALUES (1, 2);
 
INSERT INTO t1 VALUES (1, 1);
-- Expected: ERROR - Maximum trigger depth 32 exceeded at trigger "dba.tr1"
 
DROP TRIGGER tr1;
DELETE FROM t1;
 
evaluate 'Case 5. Indirect cross-trigger DEFERRED cycle (tr1 -> t2, tr2 -> t1)';
CREATE TRIGGER tr1
DEFERRED INSERT ON t1
EXECUTE INSERT INTO t2 VALUES (1, 2);
 
CREATE TRIGGER tr2
DEFERRED INSERT ON t2
EXECUTE INSERT INTO t1 VALUES (1, 2);
 
INSERT INTO t1 VALUES (1, 1);
-- Expected: ERROR - Maximum trigger depth 32 exceeded
-- (neither trigger fires itself directly, but together they form an
--  infinite cycle through the deferred-activity queue; BFS-layer depth
--  counting must catch cross-trigger cycles too, not just self-recursion)
 
DROP TRIGGER tr1;
DROP TRIGGER tr2;
DELETE FROM t1;
DELETE FROM t2;
 
evaluate 'Case 6. Bounded DEFERRED recursion that stops before max depth (32)';
CREATE TABLE t3(col1 int);
 
CREATE TRIGGER tr_bounded_ok
DEFERRED INSERT ON t3
IF ((SELECT COUNT(*) FROM t3) < 30)
EXECUTE INSERT INTO t3 VALUES (1);
 
INSERT INTO t3 VALUES (1);
SELECT COUNT(*) FROM t3;
-- Expected: succeeds normally; COUNT(*) = 30 (col1 values 1..30)
-- Confirms the depth fix does not falsely trip on legitimate bounded
-- recursive DEFERRED triggers under the limit.
 
DROP TRIGGER tr_bounded_ok;
DELETE FROM t3;
 
evaluate 'Case 7. Bounded DEFERRED recursion whose own limit exceeds max depth (32)';
CREATE TRIGGER tr_bounded_exceed
DEFERRED INSERT ON t3
IF ((SELECT COUNT(*) FROM t3) < 50)
EXECUTE INSERT INTO t3 VALUES (1);
 
INSERT INTO t3 VALUES (1);
-- Expected: ERROR - Maximum trigger depth 32 exceeded
 
DROP TRIGGER tr_bounded_exceed;
DROP TABLE t3;
 
evaluate 'Case 8. ROLLBACK before commit means DEFERRED action never fires';
-- autocommit must be OFF here: otherwise the INSERT below would commit itself immediately
autocommit off;
 
CREATE TRIGGER tr1
DEFERRED INSERT ON t1
EXECUTE INSERT INTO t1 VALUES (1, 2);
 
INSERT INTO t1 VALUES (1, 1);
ROLLBACK;
SELECT COUNT(*) FROM t1;
-- Expected: succeeds normally (no error, no hang); COUNT(*) = 0
-- DEFERRED actions only execute at commit time, so rolling back the
-- original insert must prevent the recursive trigger from ever firing.
 
autocommit on;
 
evaluate 'Case 9. DEFERRED UPDATE trigger recurses into itself';
-- Same as Case 1, but using UPDATE event instead of INSERT.
INSERT INTO t1 VALUES (1, 1);
 
CREATE TRIGGER tr_upd
DEFERRED UPDATE ON t1
EXECUTE UPDATE t1 SET col2 = col2 + 1 WHERE col1 = 1;
 
UPDATE t1 SET col2 = 2 WHERE col1 = 1;
-- Expected: ERROR - Maximum trigger depth 32 exceeded
 
DROP TRIGGER tr_upd;
DELETE FROM t1;
 
evaluate 'Case 10. mixed-event DEFERRED cycle (DELETE trigger <-> INSERT trigger)';
-- tr_del  (DEFERRED DELETE on t1) -> inserts a row
-- tr_ins2 (DEFERRED INSERT on t1) -> deletes that same row
CREATE TRIGGER tr_del
DEFERRED DELETE ON t1
EXECUTE INSERT INTO t1 VALUES (2, 2);
 
CREATE TRIGGER tr_ins2
DEFERRED INSERT ON t1
EXECUTE DELETE FROM t1 WHERE col1 = 2;
 
INSERT INTO t1 VALUES (2, 2);
-- Expected: ERROR - Maximum trigger depth 32 exceeded

DROP TABLE t1;
DROP TABLE t2;

--+ server-message off
