/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
Test DELETE locks (X_LOCK on instance) and SELECT not need locks, they are not blocked each other.

Test Scenaio:
C1 select, C2 delete, the affected rows are not overlapped
C1 commit, C2 commit
Metrics: data size = small, join query = inner join, where clause = simple (single column)

NUM_CLIENTS = 2
C1: select from table tb1 inner join table tb2;  
C2: delete from table tb1 inner join table tb2;  
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: DROP TABLE IF EXISTS tb2;
C1: CREATE TABLE tb1(id INT, col VARCHAR(10));
C1: CREATE TABLE tb2(id INT, col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(1,'abc'),(2,'def'),(3,'ghi'),(4,'jkl'),(5,'mno'),(6,'pqr'),(7,'abc');
C1: INSERT INTO tb2 VALUES(1,'stu'),(2,'vwx'),(3,'yzab'),(4,'abc'),(5,'def'),(6,'jkl'),(7,'mno'),(8,'pq');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM (select sleep(2)) x, tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 2 or b.id = 3;
C2: DELETE a,b FROM tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 1;
/* expect: no tansactions need to wait */
MC: wait until C2 ready;
MC: wait until C1 ready;
/* expect: C2 delete - tb1 id = 1 is deleted, tb2 id = 1 is deleted */
C2: SELECT * FROM tb1 order by 1,2;
C2: SELECT * FROM tb2 order by 1,2;
MC: wait until C2 ready;
/* expect: C1 - no rows deleted */
C1: SELECT * FROM tb1 order by 1,2;
C1: SELECT * FROM tb2 order by 1,2;
MC: wait until C1 ready;
C2: commit;
C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
/* expect: C1 - tb1 id = 1 is deleted, tb2 id = 1 is deleted */
C1: SELECT * FROM tb1 order by 1,2;
C1: SELECT * FROM tb2 order by 1,2;

C1: quit;
C2: quit;
