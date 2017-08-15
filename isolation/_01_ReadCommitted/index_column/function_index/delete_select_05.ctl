/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/function_index/delete_select_01.ctl 
Author: Lily

Test Point:
-    delete: X_LOCK acquired on current instance..
-    select: no row locks acquired but IS_LOCK for table,
C1 delete rows, C2 select rows, overlapped.
transactions are not blocked.
LEFT function index on two columns

NUM_CLIENTS = 2  -- use same index
C1: delete from tb1; 
C2: select * from tb1 order by 1,2;
C1: rollback;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, col VARCHAR(10),num INT);
C1: set @newincr=0;
C1: INSERT INTO tb1 SELECT (@newincr:=@newincr+1),(@newincr)%100,(@newincr)%2+1 FROM db_class a, db_class b LIMIT 500;
C1: CREATE INDEX idx_f ON tb1(LEFT(col,num));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE LEFT(col,num) >'9';
MC: wait until C1 ready;
C2: SELECT * FROM tb1 WHERE LEFT(col,num) >'9' order by id,col;
MC: wait until C2 ready;
C1: SELECT * FROM tb1 WHERE LEFT(col,num) >'9';
C1: DELETE FROM tb1 WHERE LEFT(col,num) < '1';
MC: wait until C1 ready;
C2: SELECT * FROM tb1 WHERE LEFT(col,num)<'1' order by id,col;
MC: wait until C2 ready;
C1: rollback;
MC: wait until C1 ready;
C2: SELECT count(*) FROM tb1 ORDER BY id,col;
C2: commit;

C2: quit;
C1: quit;

