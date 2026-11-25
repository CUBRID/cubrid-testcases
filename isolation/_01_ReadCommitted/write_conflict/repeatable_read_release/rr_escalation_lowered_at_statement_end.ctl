/*
Test Case: repeatable_read_release/rr_escalation_lowered_at_statement_end
Priority: 1
Reference case: CBRD-28025 (CUBRID/cubrid#8652)
Author: hgryoo

Test Point:
Under REPEATABLE READ an UPDATE of 50 rows with lock_escalation=20 raises the class lock, and the raised lock is
lowered when the statement ends.  Another transaction updates a row the first one did not touch while the first is
still open.  Before CBRD-28025 the class lock stays to commit and the other transaction times out on IX_LOCK.

NUM_CLIENTS = 2
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: UPDATE t28025_t SET v=v+1 WHERE id<=50; -- C1 locks more rows than lock_escalation
C2: set transaction lock timeout 1;
C2: UPDATE t28025_t SET v=v+100 WHERE id=80; -- C2 updates a row C1 did not touch
C2: COMMIT;
C1: COMMIT;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
C1: DROP TABLE IF EXISTS t28025_t;
C1: CREATE TABLE t28025_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t28025_t SELECT ROWNUM, 0 FROM db_class a, db_class b LIMIT 100;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
MC: wait until C1 ready;
/* C1 locks more rows than lock_escalation */
C1: UPDATE t28025_t SET v=v+1 WHERE id<=50;
MC: wait until C1 ready;
C2: set transaction lock timeout 1;
MC: wait until C2 ready;
/* C2 updates a row C1 did not touch */
C2: UPDATE t28025_t SET v=v+100 WHERE id=80;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 100 */
C1: SELECT COUNT(*) FROM t28025_t;
MC: wait until C1 ready;
/* expect 150 */
C1: SELECT SUM(v) FROM t28025_t;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
C1: DROP TABLE t28025_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
