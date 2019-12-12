/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
Test DELETE locks (X_LOCK on instance) and SELECT not need locks, they are not blocked each other.

Test Scenario:
Metrics: data size = small, join query = left [outer] join, where clause = simple (multiple columns)

NUM_CLIENTS = 2
C1: select from table tb1 left join table tb2;  
C2: delete from table tb1 left join table tb2;  
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: DROP TABLE IF EXISTS tb2;
C1: CREATE TABLE tb1(id INT, col VARCHAR(10));
C1: CREATE TABLE tb2(id INT, col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(1,'abc'),(2,'def'),(3,'ghi'),(4,'jkl'),(5,'mno'),(9,'pqr'),(10,'abc');
C1: INSERT INTO tb2 VALUES(1,'stu'),(2,'vwx'),(3,'yzab'),(4,'abc'),(5,'def'),(6,'jkl'),(7,'mno'),(8,'pqr');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT *,sleep(1) FROM tb1 a LEFT JOIN tb2 b ON a.id = b.id WHERE a.id = 2 or b.col = 'yzab' order by 1,2,3,4;
MC: wait until C1 ready;
C2: DELETE a,b FROM tb1 a LEFT JOIN tb2 b ON a.id = b.id WHERE a.id > 4;
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C2 - tb1 id = 5,9,10 is deleted, tb2 id = 5 is deleted */
C2: select * from tb1 order by id;
C2: select * from tb2 order by id;
MC: wait until C2 ready;
/* expect: C1 - no rows deleted */
C1: select * from tb1 order by id;
C1: select * from tb2 order by id;
MC: wait until C1 ready;
C2: commit;
C1: commit;
/* expect: C1 - tb1 id = 5,9,10 is deleted, tb2 id = 5 is deleted */
C1: select * from tb1 order by id;
C1: select * from tb2 order by id;

C1: commit;
C1: quit;
C2: quit;
