/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/common_index/subquery/delete_select_01.ctl
Author: Lily

Test Point:
there is a single-row subquery in select statement.
rows are overlapped.

NUM_CLIENTS = 2
C1: DELETE FROM tb1;
C2: SELECT * FROM tb1 order by 1,2; 
C1: rollback;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT,name VARCHAR(10),job VARCHAR(10),deptno INT);
C1: INSERT INTO tb1 VALUES(101,'Tom','clerk',10);INSERT INTO tb1 VALUES(102,'Jonh','salesman',10);INSERT INTO tb1 VALUES(103,'Susan','analyst',20);
C1: INSERT INTO tb1 VALUES(104,'Carol','analyst',20);INSERT INTO tb1 VALUES(105,'Jack','clerk',30);INSERT INTO tb1 VALUES(106,'Jim','analyst',10);
C1: CREATE INDEX idx_id on tb1(id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id >=104;
MC: wait until C1 ready;

C2: SELECT * FROM tb1 WHERE deptno = (SELECT deptno FROM tb1 WHERE name='Tom') ORDER BY id LIMIT 3;
MC: wait until C2 ready;
C1: SELECT * FROM tb1 WHERE deptno = (SELECT deptno FROM tb1 WHERE name='Tom') ORDER BY id LIMIT 3;
C1: rollback;
MC: wait until C1 ready;


C2: SELECT * FROM tb1 ORDER BY id;
C2: commit work;
MC: wait until C2 ready;


C2: quit;
C1: quit;
