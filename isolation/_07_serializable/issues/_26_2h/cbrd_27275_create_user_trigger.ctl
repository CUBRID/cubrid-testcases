/*
Test Case: related to CBRD-27275
Priority: 1

Test Plan:
The fix makes CREATE TRIGGER take a savepoint and roll back to it on failure, regardless of
isolation level. This file covers the user-trigger CREATE (AFTER COMMIT) under SERIALIZABLE --
step 3 (register_user_trigger for a non-table trigger) locks a db_root row instead of a class,
so this exercises a different lock path than the table-trigger case. See the other
cbrd_27275_*.ctl files under isolation/_01_ReadCommitted, _02_RepeatableRead, and
_07_serializable/issues/_26_2h for the other scenarios (CREATE table trigger, DROP, RENAME) and
isolation levels.

Test Point:
1) A failed user-trigger CREATE leaves no row behind in _db_trigger, and neither does the
   holder's own uncommitted CREATE once it is rolled back.

NUM_CLIENTS = 2
C1: hold the write lock a user-trigger CREATE takes, without commit
C2: force a user-trigger CREATE failure under lock_timeout=3 -> commit without rollback
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level serializable;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level serializable;
C2: commit;

/* C1 holds the write lock a user-trigger CREATE takes, via an uncommitted CREATE */
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
