/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/no_index_column/join/delete_select_11.ctl
Author: Lily

Test Point:
Test DELETE locks (X_LOCK on instance) and SELECT not need locks, they are not blocked each other.

Test Scenario:
C1 delete, C2 select, the affected rows are overlapped
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
C1: INSERT INTO tb1 VALUES(1,'abc'),(2,'def'),(3,'ghi'),(4,'jkl'),(5,'mno'),(9,'pqr'),(10,'abc');
C1: INSERT INTO tb2 VALUES(1,'stu'),(2,'vwx'),(3,'yzab'),(4,'abc'),(5,'def'),(6,'jkl'),(7,'mno'),(8,'pqr');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE a,b FROM tb1 a CROSS JOIN tb2 b WHERE a.id=5 and b.col='abc';
MC: wait until C1 ready;
C2: SELECT * FROM tb1 a CROSS JOIN tb2 b WHERE a.id >4 and b.id <6 order by 1,2,3,4;
MC: wait until C2 ready;
C1: rollback;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 a CROSS JOIN tb2 b WHERE a.id >4 and b.id <6 order by 1,2,3,4;
C2: commit;
C2: SELECT * FROM tb1 a CROSS JOIN tb2 b WHERE a.id >4 and b.id <6 order by 1,2,3,4;
MC: wait until C2 ready;

C1: DELETE a,b FROM tb1 a CROSS JOIN tb2 b WHERE a.id=5 and b.col='abc';
MC: wait until C1 ready;
C2: SELECT * FROM tb1 a CROSS JOIN tb2 b WHERE a.id >4 and b.id <6 order by 1,2,3,4;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 a CROSS JOIN tb2 b WHERE a.id >4 and b.id <6 order by 1,2,3,4;
C2: commit;
C2: SELECT * FROM tb1 a CROSS JOIN tb2 b WHERE a.id >4 and b.id <6 order by 1,2,3,4;
C2: commit;
C1: quit;
C2: quit;
