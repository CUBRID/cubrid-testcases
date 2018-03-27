/*
Issue Case: CUBRIDSUS-14165
Priority: 1
Reference case:
Isolation Level: Repeatable Read
Author: Ray

Test Plan: 
Test the scenario that A "serializable conflict due to concurrent updates" message is desired when using incr/decr with concurrent DELETE/UPDATE

Test Scenario:
C1 delete, C2 select incr, the affected rows are overlapped (based on where clause)
C2 try to update an unique key which C1 try to delete
C1 commit, C2 commit
Metrics: schema = single table, index = primary key, data size = small, where clause = simple

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 and C2 can only see the its own delete/select but not other transactions changes (Visibility Test) 
3) An "serializable conflict due to concurrent updates" message should be generated when C2 is unblocked
*/

MC: setup NUM_CLIENTS = 3;

/* test point 1: repeatable read */
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
DROP TABLE IF EXISTS t1;
CREATE TABLE t1(id INT PRIMARY KEY, title VARCHAR(10), read_count INT);
INSERT INTO t1 VALUES(1,'book1',10),(2,'book2',20);
COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id = 1 or id = 2;
MC: wait until C1 ready;
C2: SELECT id, title, INCR(read_count) FROM t1 WHERE id = 2;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - all data is deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;
/* expect:  A "serializable conflict due to concurrent updates" should be generated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* test point 2: repeatable read */
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
DROP TABLE IF EXISTS t1;
CREATE TABLE t1(id INT PRIMARY KEY, title VARCHAR(10), read_count INT);
INSERT INTO t1 VALUES(1,'book1',10),(2,'book2',20);
COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id = 1 or id = 2;
MC: wait until C1 ready;
C2: SELECT id, title, INCR(read_count) FROM t1 WHERE id = 2;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - all data is deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;
/* expect:  no data is select after C2 unblocked */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* test point 3: repeatable read - update*/
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
DROP TABLE IF EXISTS t1;
CREATE TABLE t1(id INT PRIMARY KEY, title VARCHAR(10), read_count INT);
INSERT INTO t1 VALUES(1,'book1',10),(2,'book2',20);
COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET title='book3' WHERE id = 1 or id = 2;
MC: wait until C1 ready;
C2: SELECT id, title, DECR(read_count) FROM t1 WHERE id = 2;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - all data is deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;
/* expect:  A "serializable conflict due to concurrent updates" should be generated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* test point 4: read committed - update*/
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
DROP TABLE IF EXISTS t1;
CREATE TABLE t1(id INT PRIMARY KEY, title VARCHAR(10), read_count INT);
INSERT INTO t1 VALUES(1,'book1',10),(2,'book2',20);
COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET title='book3' WHERE id = 1 or id = 2;
MC: wait until C1 ready;
C2: SELECT id, title, DECR(read_count) FROM t1 WHERE id = 2;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - all data is updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;
/* expect:  the data should be selected and updateds */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
