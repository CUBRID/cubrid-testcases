/*
Issue Case: CUBRIDSUS-16432
Priority: 1
Reference case:
Isolation Levels: Repeatable Read
Author: Ray

Test Plan: 
Test if the transaction could see the uncommitted data if it contains incr/decr

Test Scenario:
C1 select incr, C2 delete
C1 commit, C2 commit

Test Point:
1) C2 should not be blocked for C1 (locking)
2) C1 couldn't see the C2 changes since repeatable read
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT Unique, title VARCHAR(10), read_count INT);
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case 1 */
C1: SELECT INCR(read_count), t1.* FROM t1 WHERE read_count = 3;
MC: wait until C1 ready;
/* expect: C2 no need to wait for C1 */
C2: DELETE FROM t1 WHERE id = 1;
MC: wait until C2 ready;
/* expect: id = 1,2 should be displayed */
C1: SELECT * FROM t1 order by 1;
MC: wait until C1 ready;
C2: rollback;
MC: wait until C2 ready;
C1: SELECT * FROM t1 order by 1;
MC: wait until C1 ready;
C1: commit;

/* test case 2 */
C1: SELECT DECR(read_count), t1.* FROM t1 WHERE read_count = 5;
MC: wait until C1 ready;
/* expect: C2 no need to wait for C1 */
C2: UPDATE t1 set read_count = 6 WHERE id = 2;
C2: SELECT * FROM t1 order by 1;
MC: wait until C2 ready;
/* expect: id = 1,2 read_count = 4,4 should be displayed */
C1: SELECT * FROM t1 order by 1;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
/* expect: id = 1,2 read_count = 4,4 should be displayed */
C1: SELECT * FROM t1 order by 1;
MC: wait until C1 ready;
C1: commit;

C1: quit;
C2: quit;
