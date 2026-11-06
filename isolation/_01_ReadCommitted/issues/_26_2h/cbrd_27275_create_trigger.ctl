/*
Test Case: related to CBRD-27275
Priority: 1

Test Plan:
The fix makes CREATE TRIGGER take a savepoint and roll back to it on failure, regardless of
isolation level. This file covers the table-trigger CREATE under READ COMMITTED - see the other
cbrd_27275_*.ctl files under isolation/_01_ReadCommitted, _02_RepeatableRead, and
_07_serializable/issues/_26_2h for the other scenarios (DROP/RENAME/user trigger) and isolation
levels.

Test Point:
1) A failed CREATE TRIGGER leaves no row behind in _db_trigger or db_trigger.
2) Recreating a trigger under the same name after a failed CREATE leaves exactly one trigger,
   and only its action fires on INSERT.
3) The final DROP TRIGGER leaves no row behind either.

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

/* cleanup, plus confirm the drop itself leaves no leftover row */
C2: SET SYSTEM PARAMETERS 'lock_timeout=DEFAULT';
C2: DROP TRIGGER t1;
C2: COMMIT;
C2: SELECT unique_name, action_definition FROM _db_trigger WHERE unique_name = 'dba.t1' ORDER BY 1,2;
MC: wait until C2 ready;

C1: DROP TABLE IF EXISTS tbl;
C1: COMMIT;
MC: wait until C1 ready;

C1: quit;
C2: quit;
