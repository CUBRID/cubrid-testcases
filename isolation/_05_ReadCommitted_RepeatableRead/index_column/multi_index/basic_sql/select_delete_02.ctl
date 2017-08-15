/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/multi_index/basic_sql/select_delete_01.ctl
Author: Lily

Test Point:
-    delete: X_LOCK acquired on current instance..
-    select: no row locks acquired but IS_LOCK for table,
C1 select rows, C2 delete rows, overlapped.
transactions are not blocked.

NUM_CLIENTS = 2
C1: SELECT FROM tb1; --using index 1
C2: DELETE FROM tb1; --using index 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, acol int, name int);
C1: INSERT INTO tb1 SELECT rownum,mod(rownum,50),mod(rownum,100) FROM db_class a,db_class b where rownum<=500;
C1: CREATE INDEX idx_id ON tb1(id);
C1: CREATE INDEX idx_all ON tb1(acol,name);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM tb1 WHERE acol=10 and name>50 order by 1,2;
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE id<10;
C2: commit work;
MC: wait until C2 ready;
C1: SELECT * FROM tb1 WHERE acol=2 and name>50 order by 1,2;
C1: commit work;
C1: SELECT COUNT(*) FROM tb1 ORDER BY id;
C1: SELECT * FROM tb1 WHERE acol=10 and name>50 order by 1,2;
C1: commit;
C2: quit;
C1: quit;
