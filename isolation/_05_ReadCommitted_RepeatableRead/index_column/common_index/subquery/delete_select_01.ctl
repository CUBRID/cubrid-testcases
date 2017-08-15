/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
there is a single-row subquery in select statement.
rows are not overlapped.

NUM_CLIENTS = 2
C1: DELETE FROM tb1;
C2: select * from tb1 order by id; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT,name VARCHAR(10),job VARCHAR(10),deptno INT);
C1: INSERT INTO tb1 VALUES(101,'Tom','clerk',10);INSERT INTO tb1 VALUES(102,'Jonh','salesman',10);INSERT INTO tb1 VALUES(103,'Susan','analyst',20);
C1: INSERT INTO tb1 VALUES(104,'Carol','analyst',20);INSERT INTO tb1 VALUES(105,'Jack','Jonh',30);INSERT INTO tb1 VALUES(106,'Jim','analyst',10);
C1: CREATE INDEX idx_id on tb1(id);
C1: commit work;

/* test case */
C1: DELETE FROM tb1 WHERE id >=104;
MC: wait until C1 ready; 
C2: SELECT * FROM tb1 WHERE deptno = (SELECT deptno FROM tb1 WHERE name='Tom') ORDER BY id ;
C2: SELECT * FROM tb1 WHERE deptno = (SELECT tb1.deptno FROM tb1 WHERE name='Jonh') or name='Jim' ORDER BY id ;
MC: wait until C2 ready; 
C1: commit work;
MC: wait until C1 ready; 

C2: SELECT * FROM tb1 ORDER BY id;
C2: commit work;

C2: quit;
C1: quit;
