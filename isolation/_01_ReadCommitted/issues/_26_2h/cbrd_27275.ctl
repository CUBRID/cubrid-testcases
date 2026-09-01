/*
Test Case: related to CBRD-27275
Priority: 1
Reference case:
Author:

Test Plan:
The fix makes CREATE / DROP / RENAME TRIGGER take a savepoint and roll back to it on failure,
regardless of isolation level (previously the savepoint was skipped under READ COMMITTED, which
is why the reported bug needed READ COMMITTED to reproduce). Verify that a lock-timeout failure
committed without rollback no longer leaves the trigger catalog in a partial/inconsistent state,
for all three affected DDL statements, and that the CREATE TRIGGER repro also holds under
REPEATABLE READ and SERIALIZABLE.

Test Scenario:
1) CREATE TRIGGER, READ COMMITTED: C1 inserts into tbl and holds the lock without committing,
   C2 sets lock_timeout=3 and tries to CREATE TRIGGER with the same name (t1) -> fails with an
   SCH_M lock timeout, C2 commits without rolling back, C1 rolls back to release the lock ->
   verify no orphan row remains, then recreate under the same name and verify only one trigger
   exists and works correctly.
2) Same as (1) under REPEATABLE READ.
3) Same as (1) under SERIALIZABLE.
4) DROP TRIGGER, READ COMMITTED: same lock setup, but C2 tries to DROP an existing trigger ->
   fails with an SCH_M lock timeout, commits without rolling back -> verify the trigger is left
   fully intact (not partially removed) and still fires correctly.
5) RENAME TRIGGER, READ COMMITTED: same lock setup, but C2 tries to RENAME an existing trigger ->
   fails with a lock timeout, commits without rolling back -> verify the trigger is still found
   under its original name (no half-renamed/duplicate state) and still fires correctly.

Test Point:
1) A failed CREATE TRIGGER leaves no row behind in _db_trigger or db_trigger, under READ
   COMMITTED, REPEATABLE READ, and SERIALIZABLE alike.
2) Recreating a trigger under the same name after a failed CREATE leaves exactly one trigger,
   and only its action fires on INSERT.
3) A failed DROP TRIGGER leaves the trigger fully intact and functional.
4) A failed RENAME TRIGGER leaves the trigger under its original name only, still functional.

NUM_CLIENTS = 2
C1: hold X-lock on tbl without commit
C2: force a CREATE/DROP/RENAME TRIGGER failure under lock_timeout=3 -> commit without rollback
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: commit;

/* ========== Test 1: CREATE TRIGGER failure - READ COMMITTED ========== */

/* preparation */
C1: DROP TABLE IF EXISTS tbl;
C1: CREATE TABLE tbl(a INT);
C1: COMMIT;
MC: wait until C1 ready;

/* test case: check whether a failed CREATE TRIGGER leaves an orphan row in _db_trigger */
C1: INSERT INTO tbl VALUES (1);
MC: wait until C1 ready;

C2: SET SYSTEM PARAMETERS 'lock_timeout=3';
C2: CREATE TRIGGER t1 AFTER INSERT ON tbl EXECUTE PRINT 'OLD';
C2: COMMIT;
MC: wait until C2 ready;

C1: ROLLBACK;
MC: wait until C1 ready;

C2: SELECT unique_name, action_definition FROM _db_trigger WHERE unique_name = 'dba.t1' ORDER BY 1,2;
C2: SELECT trigger_name, owner_name, target_class_name FROM db_trigger WHERE trigger_name = 't1' ORDER BY 1,2;
MC: wait until C2 ready;

/* recreate under the same name -> without an orphan, exactly one trigger should exist */
C2: CREATE TRIGGER t1 AFTER INSERT ON tbl EXECUTE PRINT 'NEW';
C2: COMMIT;
MC: wait until C2 ready;

C2: SELECT unique_name, action_definition FROM _db_trigger WHERE unique_name = 'dba.t1' ORDER BY 1,2;
C2: SELECT trigger_name, owner_name, target_class_name FROM db_trigger WHERE trigger_name = 't1' ORDER BY 1,2;
C2: INSERT INTO tbl VALUES (2);
C2: COMMIT;
MC: wait until C2 ready;

/* cleanup */
C2: SET SYSTEM PARAMETERS 'lock_timeout=DEFAULT';
C2: DROP TRIGGER t1;
C2: COMMIT;
MC: wait until C2 ready;

C1: DROP TABLE IF EXISTS tbl;
C1: COMMIT;
MC: wait until C1 ready;

/* ========== Test 2: CREATE TRIGGER failure - REPEATABLE READ ========== */

C1: set transaction isolation level repeatable read;
C2: set transaction isolation level repeatable read;

C1: CREATE TABLE tbl(a INT);
C1: COMMIT;
MC: wait until C1 ready;

C1: INSERT INTO tbl VALUES (1);
MC: wait until C1 ready;

C2: SET SYSTEM PARAMETERS 'lock_timeout=3';
C2: CREATE TRIGGER t1 AFTER INSERT ON tbl EXECUTE PRINT 'OLD';
C2: COMMIT;
MC: wait until C2 ready;

C1: ROLLBACK;
MC: wait until C1 ready;

C2: SELECT unique_name, action_definition FROM _db_trigger WHERE unique_name = 'dba.t1' ORDER BY 1,2;
C2: SELECT trigger_name, owner_name, target_class_name FROM db_trigger WHERE trigger_name = 't1' ORDER BY 1,2;
MC: wait until C2 ready;

C2: CREATE TRIGGER t1 AFTER INSERT ON tbl EXECUTE PRINT 'NEW';
C2: COMMIT;
MC: wait until C2 ready;

C2: SELECT unique_name, action_definition FROM _db_trigger WHERE unique_name = 'dba.t1' ORDER BY 1,2;
C2: SELECT trigger_name, owner_name, target_class_name FROM db_trigger WHERE trigger_name = 't1' ORDER BY 1,2;
C2: INSERT INTO tbl VALUES (2);
C2: COMMIT;
MC: wait until C2 ready;

/* cleanup */
C2: SET SYSTEM PARAMETERS 'lock_timeout=DEFAULT';
C2: DROP TRIGGER t1;
C2: COMMIT;
MC: wait until C2 ready;

C1: DROP TABLE IF EXISTS tbl;
C1: COMMIT;
MC: wait until C1 ready;

/* ========== Test 3: CREATE TRIGGER failure - SERIALIZABLE ========== */

C1: set transaction isolation level serializable;
C2: set transaction isolation level serializable;

C1: CREATE TABLE tbl(a INT);
C1: COMMIT;
MC: wait until C1 ready;

C1: INSERT INTO tbl VALUES (1);
MC: wait until C1 ready;

C2: SET SYSTEM PARAMETERS 'lock_timeout=3';
C2: CREATE TRIGGER t1 AFTER INSERT ON tbl EXECUTE PRINT 'OLD';
C2: COMMIT;
MC: wait until C2 ready;

C1: ROLLBACK;
MC: wait until C1 ready;

C2: SELECT unique_name, action_definition FROM _db_trigger WHERE unique_name = 'dba.t1' ORDER BY 1,2;
C2: SELECT trigger_name, owner_name, target_class_name FROM db_trigger WHERE trigger_name = 't1' ORDER BY 1,2;
MC: wait until C2 ready;

C2: CREATE TRIGGER t1 AFTER INSERT ON tbl EXECUTE PRINT 'NEW';
C2: COMMIT;
MC: wait until C2 ready;

C2: SELECT unique_name, action_definition FROM _db_trigger WHERE unique_name = 'dba.t1' ORDER BY 1,2;
C2: SELECT trigger_name, owner_name, target_class_name FROM db_trigger WHERE trigger_name = 't1' ORDER BY 1,2;
C2: INSERT INTO tbl VALUES (2);
C2: COMMIT;
MC: wait until C2 ready;

/* cleanup */
C2: SET SYSTEM PARAMETERS 'lock_timeout=DEFAULT';
C2: DROP TRIGGER t1;
C2: COMMIT;
MC: wait until C2 ready;

C1: DROP TABLE IF EXISTS tbl;
C1: COMMIT;
MC: wait until C1 ready;

/* ========== Test 4: DROP TRIGGER failure - READ COMMITTED ========== */

C1: set transaction isolation level read committed;
C2: set transaction isolation level read committed;

/* preparation: this time the trigger is created successfully up front */
C1: CREATE TABLE tbl(a INT);
C1: CREATE TRIGGER t1 AFTER INSERT ON tbl EXECUTE PRINT 'ORIG';
C1: COMMIT;
MC: wait until C1 ready;

/* test case: check whether a failed DROP TRIGGER leaves the trigger partially removed */
C1: INSERT INTO tbl VALUES (1);
MC: wait until C1 ready;

C2: SET SYSTEM PARAMETERS 'lock_timeout=3';
C2: DROP TRIGGER t1;
C2: COMMIT;
MC: wait until C2 ready;

C1: ROLLBACK;
MC: wait until C1 ready;

/* the trigger must still be fully intact: exactly one row, still resolvable by name */
C2: SELECT unique_name, action_definition FROM _db_trigger WHERE unique_name = 'dba.t1' ORDER BY 1,2;
C2: SELECT trigger_name, owner_name, target_class_name FROM db_trigger WHERE trigger_name = 't1' ORDER BY 1,2;
C2: INSERT INTO tbl VALUES (2);
C2: COMMIT;
MC: wait until C2 ready;

/* cleanup: DROP TRIGGER must succeed now that no other session holds the lock */
C2: SET SYSTEM PARAMETERS 'lock_timeout=DEFAULT';
C2: DROP TRIGGER t1;
C2: COMMIT;
MC: wait until C2 ready;

C1: DROP TABLE IF EXISTS tbl;
C1: COMMIT;
MC: wait until C1 ready;

/* ========== Test 5: RENAME TRIGGER failure - READ COMMITTED ========== */

/* preparation: trigger created successfully up front */
C1: CREATE TABLE tbl(a INT);
C1: CREATE TRIGGER t1 AFTER INSERT ON tbl EXECUTE PRINT 'ORIG';
C1: COMMIT;
MC: wait until C1 ready;

/* test case: check whether a failed RENAME TRIGGER leaves a half-renamed/duplicate state */
C1: INSERT INTO tbl VALUES (1);
MC: wait until C1 ready;

C2: SET SYSTEM PARAMETERS 'lock_timeout=3';
C2: RENAME TRIGGER t1 AS t1_renamed;
C2: COMMIT;
MC: wait until C2 ready;

C1: ROLLBACK;
MC: wait until C1 ready;

/* only the original name must exist - no leftover row under the new name */
C2: SELECT unique_name, action_definition FROM _db_trigger WHERE unique_name IN ('dba.t1', 'dba.t1_renamed') ORDER BY 1,2;
C2: SELECT trigger_name, owner_name, target_class_name FROM db_trigger WHERE trigger_name IN ('t1', 't1_renamed') ORDER BY 1,2;
C2: INSERT INTO tbl VALUES (2);
C2: COMMIT;
MC: wait until C2 ready;

/* cleanup */
C2: SET SYSTEM PARAMETERS 'lock_timeout=DEFAULT';
C2: DROP TRIGGER t1;
C2: COMMIT;
MC: wait until C2 ready;

C1: DROP TABLE IF EXISTS tbl;
C1: COMMIT;
MC: wait until C1 ready;

C1: quit;
C2: quit;
