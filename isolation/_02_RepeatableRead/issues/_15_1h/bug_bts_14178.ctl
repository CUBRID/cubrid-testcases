/*
Issue Case: CUBRIDSUS-14178 
Priority: 1
Reference case:
Isolation Level: Repeatable Read/Read Committed
Author: Ray

Test Plan: 
Test the scenario that the select transaction should not blocked if a concurrent transaction using DML with ROWNUM function

Test Scenario:
C1 delete with ROWNUM, C2 select, the affected rows are overlapped (based on where clause)
C1 commit, C2 commit
Metrics: schema = single table, index = no index, data size = small, where clause = simple

Test Point:
1) C2 doesn't need to wait for C1 (locking)
2) C1 could see the C1 changes (read committed), and couldn't see C1 changes (repeatable read)
*/

MC: setup NUM_CLIENTS = 3;

/* test point 1: repeatable read */
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
DROP TABLE IF EXISTS t1;
CREATE TABLE t1(id INT, title VARCHAR(10));
INSERT INTO t1 VALUES(1,'abc'),(2,'def'),(3,'ghi');
COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE ROWNUM = 1;
MC: wait until C1 ready;
C2: select * from t1 order by 1,2;
/* expect: C2 doesn't need to wait for C1 */
MC: wait until C2 ready;
C1: commit;
C1: UPDATE t1 SET title = 'abcd' WHERE ROWNUM = 2;
MC: wait until C1 ready;
/* expect:  C2 doesn't need to wait for C1 */
C2: select * from t1 order by 1,2;
MC: wait until C2 ready;
C1: commit;
C2: select * from t1 order by 1,2;
C2: commit;

/* test point 2: read committed */
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
DROP TABLE IF EXISTS t1,t2;
CREATE TABLE t1(id INT, title VARCHAR(10));
INSERT INTO t1 VALUES(1,'abc'),(2,'def'),(3,'ghi');
rename table t1 as t2;
create table t1 as select * from t2 order by id;
COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE ROWNUM = 1;
MC: wait until C1 ready;
C2: select * from t1 order by 1,2;
/* expect: C2 doesn't need to wait for C1 */
MC: wait until C2 ready;
C1: commit;
C1: UPDATE t1 SET title = 'abcd' WHERE ROWNUM < 2;
MC: wait until C1 ready;
/* expect:  C2 doesn't need to wait for C1 */
C2: select title from t1 where title = 'abcd';
MC: wait until C2 ready;
C1: commit;
C2: select title from t1 where title = 'abcd';
C2: commit;

C1: quit;
C2: quit;
