/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
Test DELETE locks (X_LOCK on instance) and SELECT not need locks, they are not blocked each other.

Test Scenario:
C1 delete, C2 select, the affected rows are not overlapped
C1 commit, C2 commit
Metrics: data size = small, join query = cross join, where clause = simple (multiple columns)

NUM_CLIENTS = 2
C1: delete from table tb1 cross join table tb2;  
C2: select from table tb1 cross join table tb2;  
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
C1: CREATE INDEX idx_id on tb1(id);
C1: CREATE INDEX idx_id on tb2(id);
C1: INSERT INTO tb1 VALUES(1,'abc'),(2,'def'),(3,'ghi'),(4,'jkl'),(5,'mno'),(9,'pqr'),(10,'abc');
C1: INSERT INTO tb2 VALUES(1,'stu'),(2,'vwx'),(3,'yzab'),(4,'abc'),(5,'def'),(6,'jkl'),(7,'mno'),(8,'pqr');
C1: commit work;

/* test case */
C1: DELETE a,b FROM tb1 a CROSS JOIN tb2 b WHERE a.id>5 and b.id > 5;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 a CROSS JOIN tb2 b WHERE a.id <= 2 and b.id < 5 ;
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C1 - tb1 id = 9,10 is deleted, tb2 id = 6,7,8 is deleted */
C1: select * from tb1 order by id;
C1: select * from tb2 order by id;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 a CROSS JOIN tb2 b WHERE a.id <= 2 and b.id < 5 ;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 a CROSS JOIN tb2 b WHERE a.id <= 2 and b.id < 5 ;
C2: commit;
C1: quit;
C2: quit;
