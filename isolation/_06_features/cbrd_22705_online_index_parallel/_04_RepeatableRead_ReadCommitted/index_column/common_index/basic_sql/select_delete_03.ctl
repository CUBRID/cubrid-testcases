/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/select_delete_01.ctl
Author: Lily

Test Point:
-    delete: X_LOCK acquired on current instance..
-    select: no row locks acquired but IS_LOCK for table,
             but can see rows before the queries began.
C1 select rows, C2 delete rows, overlapped.
transactions are not blocked.

NUM_CLIENTS = 2
C1: SELECT * FROM tb1 order by 1,2;
C2: DELETE FROM tb1 WHERE id <= 3;
C2: rollback;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, col VARCHAR(10) );
C1: CREATE INDEX idx_id on tb1(col) with online parallel 3;
C1: CREATE INDEX idx_col on tb1(id) with online parallel 3;
C1: INSERT INTO tb1 VALUES(1,'do');INSERT INTO tb1 VALUES(2,'make');INSERT INTO tb1 VALUES(3,'spell');INSERT INTO tb1 VALUES(4,'have');INSERT INTO tb1 VALUES(6,'be');INSERT INTO tb1 VALUES(8,'run');INSERT INTO tb1 VALUES(9,'keep');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT tb1.* FROM tb1 WHERE id>0 ORDER BY id,2;
MC: sleep 1;
C2: DELETE FROM tb1 WHERE id=8;
MC: wait until C2 ready;
C2: SELECT * FROM tb1 WHERE id>0 ORDER BY id,2;
MC: wait until C2 ready; 
C2: rollback;
C1: commit work;
C1: SELECT * FROM tb1 WHERE id>0 ORDER BY id,2;
MC: wait until C1 ready;

C1: commit;
C2: quit;
C1: quit;
