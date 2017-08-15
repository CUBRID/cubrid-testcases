/*
Issue Case: CUBRIDSUS-14645
Priority: 1
Reference case:
Isolation Levels: Repeatable Read
Author: Ray

Test Plan: 
Test the scenario that the locking behaviors are different when execute JOIN

Test Scenario:
C1 delete inner join, C2 select inner join
C1 rollback, C2 rollback
Metrics: schema = single table, index = no index, data size = small, where clause = simple

Test Point:
1) C2 shouldn't needs to be blocked wait for C1 (locking)
2) C2 couldn't see the C1 changes since repeatable read
*/

MC: setup NUM_CLIENTS = 2;

/* test point 1: repeatable read */
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT);
C1: INSERT INTO tb1 VALUES(1),(2);
C1: DROP TABLE IF EXISTS tb2;
C1: CREATE TABLE tb2(id INT);
C1: INSERT INTO tb2 VALUES(1),(2),(3);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE a,b FROM tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 2;
MC: wait until C1 ready;
C2: select * from tb1 a INNER JOIN tb2 b WHERE a.id = b.id ORDER by a.id;
/* expect: C2 doesn't need to wait for C1 */
MC: wait until C2 ready;
C1: rollback;
C2: rollback;

C1: DELETE a,b FROM tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 2 or b.id = 2;
MC: wait until C1 ready;
C2: select * from tb1 a INNER JOIN tb2 b WHERE a.id = b.id ORDER by a.id;
/* expect: C2 doesn't need to wait for C1 */
MC: wait until C2 ready;
C1: rollback;
C2: rollback;

/* test point 2: read committed */
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT);
C1: INSERT INTO tb1 VALUES(1),(2);
C1: DROP TABLE IF EXISTS tb2;
C1: CREATE TABLE tb2(id INT);
C1: INSERT INTO tb2 VALUES(1),(2),(3);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE a,b FROM tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 2;
MC: wait until C1 ready;
C2: select * from tb1 a INNER JOIN tb2 b WHERE a.id = b.id ORDER by a.id;
/* expect: C2 doesn't need to wait for C1 */
MC: wait until C2 ready;
C1: rollback;
C2: rollback;

C1: DELETE a,b FROM tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 2 or b.id = 2;
MC: wait until C1 ready;
C2: select * from tb1 a INNER JOIN tb2 b WHERE a.id = b.id ORDER by a.id;
/* expect: C2 doesn't need to wait for C1 */
MC: wait until C2 ready;
C1: commit;
C1: DELETE a,b FROM tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 1 or b.id = 1;
MC: wait until C1 ready;
C2: select * from tb1 a INNER JOIN tb2 b WHERE a.id = b.id ORDER by a.id;
/* expect: C2 doesn't need to wait for C1 */
MC: wait until C2 ready;
C2: commit;

C1: quit;
C2: quit;