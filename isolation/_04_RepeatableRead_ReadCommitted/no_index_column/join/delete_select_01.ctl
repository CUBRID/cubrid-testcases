/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
Test DELETE locks (X_LOCK on instance) and SELECT not need locks, they are not blocked each other.

Test Scenaio:
C1 delete, C2 select, the affected rows are not overlapped
C1 commit, C2 commit
Metrics: data size = small, join query = inner join, where clause = simple (single column)

NUM_CLIENTS = 2
C1: delete from table tb1 inner join table tb2;  
C2: select from table tb1 inner join table tb2;  
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: DROP TABLE IF EXISTS tb2;
C1: CREATE TABLE tb1(id INT, col VARCHAR(10));
C1: CREATE TABLE tb2(id INT, col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(1,'abc');INSERT INTO tb1 VALUES(2,'def');INSERT INTO tb1 VALUES(3,'ghi');INSERT INTO tb1 VALUES(4,'jkl');INSERT INTO tb1 VALUES(5,'mno');INSERT INTO tb1 VALUES(6,'pqr');INSERT INTO tb1 VALUES(7,'abc');
C1: INSERT INTO tb2 VALUES(1,'stu');INSERT INTO tb2 VALUES(2,'vwx');INSERT INTO tb2 VALUES(3,'yzab');INSERT INTO tb2 VALUES(4,'abc');INSERT INTO tb2 VALUES(5,'def');INSERT INTO tb2 VALUES(6,'jkl');INSERT INTO tb2 VALUES(7,'mno');INSERT INTO tb2 VALUES(8,'pq');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id = 2;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 2 or b.id = 3 order by 1,2,3,4;
/* expect: no tansactions need to wait */
MC: wait until C2 ready;
/* expect: C1 - tb1 id = 1 is deleted, tb2 id = 1 is deleted */
C1: SELECT * FROM tb1 order by 1,2;
C1: SELECT * FROM tb2 order by 1,2;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 2 or b.id = 3;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
