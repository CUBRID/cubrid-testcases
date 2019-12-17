/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/multi_index/basic_sql/select_delete_01.ctl 
Author: Lily

Test Point:
C1 select rows, C2 delete rows,overlapped.
transactions are not blocked.

NUM_CLIENTS = 2
C1: SELECT * FROM tb1 order by 1,2; --equivalence 
C2: DELETE FROM tb1;  
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(101,'Tom');INSERT INTO tb1 VALUES(102,'Mike');INSERT INTO tb1 VALUES(103,'Stephan');INSERT INTO tb1 VALUES(102,'Lucy');INSERT INTO tb1 VALUES(103,'Elena');INSERT INTO tb1 VALUES(103,NULL);INSERT INTO tb1 VALUES(104,NULL);INSERT INTO tb1 VALUES(105,NULL);INSERT INTO tb1 VALUES(105,'Ben');
C1: CREATE INDEX idx_1 ON tb1(id,col) with online parallel 3;
C1: CREATE INDEX idx_2 ON tb1(col) with online parallel 3;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM tb1 WHERE col IS NULL order by 1,2;
C1: SELECT * FROM tb1 WHERE id > 103 order by 1,2;
C1: SELECT * FROM tb1 WHERE col LIKE 'S%' order by 1,2;
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE id = 103 AND col IS NULL;
C2: DELETE FROM tb1 WHERE col= 'Ben';
C2: SELECT * FROM tb1 ORDER BY id,2;
C2: commit work;
MC: wait until C2 ready;
C1: SELECT * FROM tb1 ORDER BY id,2;
C1: commit work;
C2: quit;
C1: quit;
