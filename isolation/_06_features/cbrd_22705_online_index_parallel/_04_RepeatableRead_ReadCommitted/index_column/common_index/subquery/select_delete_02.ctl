/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/common_index/subquery/delete_select_01.ctl
Author: Lily

Test Point:
there is a multiple-row subquery in select statement.

NUM_CLIENTS = 2
C1: SELECT * FROM tb1 order by 1,2;
C2: DELETE FROM tb1;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id int,name varchar(10),age int);
C1: INSERT INTO tb1 VALUES(1001,'Tom',56);INSERT INTO tb1 VALUES(1002,'Jonh',25);INSERT INTO tb1 VALUES(1003,'Susan',56);
C1: INSERT INTO tb1 VALUES(1004,'Carol',21);INSERT INTO tb1 VALUES(1005,'Jack',39);INSERT INTO tb1 VALUES(1006,'Jim',56);
C1: CREATE INDEX idx_id on tb1(id) with online parallel 3;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT tb1.* FROM tb1 WHERE age=(SELECT MAX(age) FROM tb1) ORDER BY id,2,3;
MC: wait until C1 ready; 
C2: DELETE FROM tb1 WHERE id >=1004;
C2: commit work;
MC: wait until C2 ready;

C1: SELECT * FROM tb1 WHERE age=(SELECT MAX(age) FROM tb1) ORDER BY id,2,3;
C1: commit;
MC: wait until C1 ready;

C2: quit;
C1: quit;
