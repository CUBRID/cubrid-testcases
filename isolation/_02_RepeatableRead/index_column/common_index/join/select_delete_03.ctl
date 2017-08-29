/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/no_index_column/join/select_delete_01.ctl
Author: Lily

Test Point:
Test DELETE locks (X_LOCK on instance) and SELECT not need locks, they are not blocked each other.

Test Scenario:
C1 select, C2 delete, the affected rows are overlapped
C1 commit, C2 commit
Metrics: data size = small, join query = inner join, where clause = simple (multiple columns)

NUM_CLIENTS = 2
C1: select from table tb1 inner join table tb2;  
C2: delete from table tb1 inner join table tb2;  
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
C1: INSERT INTO tb1 VALUES(1,'abc');INSERT INTO tb1 VALUES(2,'def');INSERT INTO tb1 VALUES(3,'ghi');INSERT INTO tb1 VALUES(4,'jkl');INSERT INTO tb1 VALUES(5,'mno');INSERT INTO tb1 VALUES(6,'pqr');INSERT INTO tb1 VALUES(7,'abc');
C1: INSERT INTO tb2 VALUES(1,'stu');INSERT INTO tb2 VALUES(2,'vwx');INSERT INTO tb2 VALUES(3,'yzab');INSERT INTO tb2 VALUES(4,'abc');INSERT INTO tb2 VALUES(5,'def');INSERT INTO tb2 VALUES(6,'jkl');INSERT INTO tb2 VALUES(7,'mno');INSERT INTO tb2 VALUES(8,'pqr');
C1: commit work;

/* rollback */
C1: SELECT *,sleep(1) FROM tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 2 or b.col = 'yzab' order by 1;
C2: DELETE a,b FROM tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 2 or b.col = 'yzab' ;
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C2 - tb1 id = 2 is deleted, tb2 id = 3 is deleted */
C2: select * from tb1 order by id;
C2: select * from tb2 order by id;
MC: wait until C2 ready;
C1: SELECT *,sleep(1) FROM tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 2 or b.col = 'yzab' order by 1;
C2: rollback;
MC: wait until C2 ready;
C1: SELECT *,sleep(1) FROM tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 2 or b.col = 'yzab' order by a.id;
C1: commit;
MC: wait until C1 ready;

/* commit */
C1: SELECT *,sleep(1)  FROM tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 2 or b.col = 'yzab' order by a.id;
C2: DELETE a,b FROM tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 2 or b.col = 'yzab' ;
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C2 - tb1 id = 2 is deleted, tb2 id = 3 is deleted */
C2: select * from tb1 order by id;
C2: select * from tb2 order by id;
C2: commit;
MC: wait until C2 ready;
C1: SELECT * FROM tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 2 or b.col = 'yzab' order by 1;
C1: commit;
MC: wait until C1 ready;
C1: SELECT * FROM tb1 a INNER JOIN tb2 b ON a.id = b.id WHERE a.id = 2 or b.col = 'yzab' order by 1;
C1: commit;
C1: quit;
C2: quit;
