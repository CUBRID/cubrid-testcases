/*
Test Case: related to CBRD-27275
Priority: 1
Reference case:
Author:Zion Yun

Test Plan:
The fix makes CREATE / DROP / RENAME TRIGGER take a savepoint and roll back to it on failure,
regardless of isolation level (previously the savepoint was skipped under READ COMMITTED, which
is why the reported bug needed READ COMMITTED to reproduce). This file covers READ COMMITTED
only; the REPEATABLE READ and SERIALIZABLE variants of the CREATE TRIGGER repro live in their
own files (see isolation/_02_RepeatableRead/issues/_26_2h/cbrd_27275.ctl and
cbrd_27275_serializable.ctl in this directory).

Test Point:
1) A failed CREATE TRIGGER (table or user trigger) leaves no row behind in _db_trigger.
2) Recreating a trigger under the same name after a failed CREATE leaves exactly one trigger,
   and only its action fires on INSERT.
3) A failed DROP TRIGGER leaves the trigger fully intact and functional.
4) A failed RENAME TRIGGER leaves the trigger under its original name only, still functional.

NUM_CLIENTS = 2
C1: hold a lock without commit (X-lock on tbl, or the dba row of db_user for the user trigger)
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

/* ========== Test 1: CREATE TRIGGER failure - table trigger ========== */

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

/* cleanup, plus confirm the drop itself leaves no leftover row */
C2: SET SYSTEM PARAMETERS 'lock_timeout=DEFAULT';
C2: DROP TRIGGER t1;
C2: COMMIT;
C2: SELECT unique_name, action_definition FROM _db_trigger WHERE unique_name = 'dba.t1' ORDER BY 1,2;
MC: wait until C2 ready;

C1: DROP TABLE IF EXISTS tbl;
C1: COMMIT;
MC: wait until C1 ready;

/* ========== Test 2: DROP TRIGGER failure ========== */

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

/* ========== Test 3: RENAME TRIGGER failure ========== */

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

/* ========== Test 4: CREATE TRIGGER failure - user trigger (AFTER COMMIT) ========== */
/* run last: register_user_trigger locks the owner's db_user row, not a class, and an unfixed
   build leaves an AFTER-COMMIT trigger that would fire on every later COMMIT in this file */

/* C1 holds the write lock on the dba row of db_user via an uncommitted user-trigger CREATE */
C1: CREATE TRIGGER user_trg_holder AFTER COMMIT EXECUTE PRINT 'HOLDER';
MC: wait until C1 ready;

/* C2 fails registering another user trigger under the same owner and commits the failure */
C2: SET SYSTEM PARAMETERS 'lock_timeout=3';
C2: CREATE TRIGGER user_trg_victim AFTER COMMIT EXECUTE PRINT 'VICTIM';
C2: COMMIT;
MC: wait until C2 ready;

/* C1 rolls back, so user_trg_holder is never committed either */
C1: ROLLBACK;
MC: wait until C1 ready;

/* neither name should have an orphan row */
C2: SELECT unique_name, action_definition FROM _db_trigger WHERE unique_name IN ('dba.user_trg_holder', 'dba.user_trg_victim') ORDER BY 1,2;
MC: wait until C2 ready;

C2: SET SYSTEM PARAMETERS 'lock_timeout=DEFAULT';
MC: wait until C2 ready;

C1: quit;
C2: quit;
