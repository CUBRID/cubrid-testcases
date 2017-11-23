/*
Issue Case: CUBRIDSUS-14170
Priority: 1
Reference case:
Isolation Level: Repeatable Read/Read Committed
Author: Ray

Test Plan: 
Test the scenario of the identical DML queries encounters various locking behaviors in one transaction

Test Scenario:
C1 update, C2 delete/update, the affected rows are not overlapped (based on where clause)
C1 commit, C2 commit
Metrics: schema = single table, index = primary key, data size = small, where clause = simple

Test Point:
1) The identical DML queries should encounters identical locking behaviors in one transaction (repeatable read)
2) The identical DML queries may encounters various locking behaviors in one transaction (read committed) 
*/

MC: setup NUM_CLIENTS = 3;

/* test point 1: repeatable read */
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
DROP TABLE IF EXISTS t1;
CREATE TABLE t1(id INT PRIMARY KEY, title VARCHAR(10));
INSERT INTO t1 VALUES(1,'abc'),(2,'def');
COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: update t1 set title = 'abcd' where id = 1;
MC: wait until C1 ready;
C2: delete from t1 where title = 'abcd';
/* expect: C2 doesn't need to wait for C1 */
MC: wait until C2 ready;
C1: commit;
C1: delete from t1 where id = 1;
MC: wait until C1 ready;
/* expect:  C2 doesn't need to wait for C1 */
C2: delete from t1 where title = 'abcd';
MC: wait until C2 ready;
C1: commit;
C2: select * from t1 order by 1;
C2: commit;

DROP TABLE IF EXISTS t1;
CREATE TABLE t1(id INT PRIMARY KEY, title VARCHAR(10));
INSERT INTO t1 VALUES(1,'abc'),(2,'def');
COMMIT WORK;
MC: wait until C1 ready;

C1: update t1 set title = 'abcd' where id = 1;
MC: wait until C1 ready;
C2: update t1 set title = 'abc' where title = 'abcd';
/* expect: C2 doesn't need to wait for C1 */
MC: wait until C2 ready;
C1: commit;
C1: delete from t1 where id = 1;
MC: wait until C1 ready;
/* expect:  C2 doesn't need to wait for C1 */
C2: update t1 set title = 'abc' where title = 'abcd';
MC: wait until C2 ready;
C1: commit;
C2: select * from t1 order by 1;
C2: commit;

/* test point 2: read committed */
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
DROP TABLE IF EXISTS t1;
CREATE TABLE t1(id INT PRIMARY KEY, title VARCHAR(10));
INSERT INTO t1 VALUES(1,'abc'),(2,'def');
COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: update t1 set title = 'abcd' where id = 1;
MC: wait until C1 ready;
C2: delete from t1 where title = 'abcd';
/* expect: C2 doesn't needs to wait for C1 */
MC: wait until C2 ready;
C1: commit;
C1: delete from t1 where id = 1;
MC: wait until C1 ready;
C2: delete from t1 where title = 'abcd';
/* expect:  C2 needs to wait for C1 */
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: select * from t1 order by 1;
C2: commit;


C1: quit;
C2: quit;
