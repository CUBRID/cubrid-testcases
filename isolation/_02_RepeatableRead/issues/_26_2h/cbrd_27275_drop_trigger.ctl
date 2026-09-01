/*
Test Case: related to CBRD-27275
Priority: 1

Test Plan:
The fix makes DROP TRIGGER take a savepoint and roll back to it on failure, regardless of
isolation level. This file covers DROP TRIGGER under REPEATABLE READ - see the other
cbrd_27275_*.ctl files under isolation/_01_ReadCommitted, _02_RepeatableRead, and
_07_serializable/issues/_26_2h for the other scenarios (CREATE table/user trigger, RENAME) and
isolation levels.

Test Point:
1) A failed DROP TRIGGER leaves the trigger fully intact (not partially removed) and functional.

NUM_CLIENTS = 2
C1: hold X-lock on tbl without commit
C2: force a DROP TRIGGER failure under lock_timeout=3 -> commit without rollback
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;

/* preparation: the trigger is created successfully up front */
C1: DROP TABLE IF EXISTS tbl;
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

C1: quit;
C2: quit;
