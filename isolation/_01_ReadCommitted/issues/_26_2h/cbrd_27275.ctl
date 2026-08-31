/*
Test Case: related to CBRD-27275
Priority: 1
Reference case:
Author:

Test Plan:
Verify that when CREATE TRIGGER fails partway through (at sm_add_trigger) but the failed
statement is committed instead of rolled back, an orphan row is left in _db_trigger, and
recreating a trigger with the same name afterward results in two trigger rows sharing that name.
(Reproduction requires READ COMMITTED isolation; the fix takes a savepoint and rolls back to it
regardless of isolation level.)

Test Scenario:
C1 inserts into tbl and holds the lock without committing,
C2 sets lock_timeout=3 and tries to CREATE TRIGGER with the same name (t1) -> fails with an
SCH_M lock timeout,
C2 commits without rolling back the failed statement,
C1 issues ROLLBACK to release the lock,
Check whether an orphan row remains in _db_trigger -> it must not,
Recreate the trigger with the same name -> verify it works correctly and only one trigger exists

Test Point:
1) When CREATE TRIGGER fails, no row is left behind in _db_trigger (no orphan row)
2) Recreating the trigger under the same name afterward leaves exactly one trigger, and only its
action fires on INSERT

NUM_CLIENTS = 2
C1: hold X-lock on tbl without commit
C2: force a CREATE TRIGGER failure under lock_timeout=3 -> commit without rollback
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: commit;

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

C1: quit;
C2: quit;
