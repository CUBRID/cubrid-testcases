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
two index, unique index and LOWER function index on the same column

NUM_CLIENTS = 2  -- use different index
C1: delete from tb1 where col='Lucy'; 
C2: select * from tb1 where LOWER(col) like 'l%'
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(101,'Tom');INSERT INTO tb1 VALUES(102,'Mike');INSERT INTO tb1 VALUES(103,'Stephan');INSERT INTO tb1 VALUES(102,'Lucy');INSERT INTO tb1 VALUES(103,'Elena');INSERT INTO tb1 VALUES(103,'laura');INSERT INTO tb1 VALUES(104,'L');INSERT INTO tb1 VALUES(105,NULL);INSERT INTO tb1 VALUES(105,'Ben');
C1: CREATE UNIQUE INDEX idx_col ON tb1(col) with online parallel 7;
C1: CREATE INDEX idx_2 ON tb1(LOWER(col)) with online parallel 3;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE col='Lucy';
MC: wait until C1 ready;

C2: SELECT * FROM tb1 WHERE LOWER(col) LIKE 'l%' order by id;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: commit work;
C2: SELECT * FROM tb1 ORDER BY id,col;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

