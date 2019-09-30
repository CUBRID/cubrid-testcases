/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
there are CASE keyword in select statement.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id <= 3;
C2: SELECT * FROM tb1 order by 1,2; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, name VARCHAR(10),deptno INT,salary INT );
C1: INSERT INTO tb1 VALUES(1,'Kim',60,400);INSERT INTO tb1 VALUES(2,'Moy',90,300);INSERT INTO tb1 VALUES(3,'Jones',30,540);INSERT INTO tb1 VALUES(4,'Smith',60,550);
C1: INSERT INTO tb1 VALUES(5,'Kim',60,380);INSERT INTO tb1 VALUES(6,'Smith',60,240);INSERT INTO tb1 VALUES(7,'Brown',90,NULL);
C1: CREATE INDEX idx_id on tb1(id) with online parallel 3;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id <= 3;
MC: wait until C1 ready;
C2: SELECT SUM(CASE deptno WHEN 90 THEN 1 END) dept_90, SUM(CASE deptno WHEN 60 THEN 1 END) dept_60 FROM tb1 WHERE salary >=300 AND deptno in (90,60); 
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
C2: SELECT SUM(CASE deptno WHEN 90 THEN 1 END) dept_90, SUM(CASE deptno WHEN 60 THEN 1 END) dept_60 FROM tb1 WHERE salary >=300 AND deptno in (90,60);
C2: SELECT * FROM tb1 order by 1,2;
C2: commit work;

C2: quit;
C1: quit;
