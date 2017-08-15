/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
there are EXISTS keyword in select statement.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id <= 3;
C2: select * from tb1 order by id; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, name VARCHAR(10),job VARCHAR(10),salary INT );
C1: INSERT INTO tb1 VALUES(1,'Kim','dev',400);INSERT INTO tb1 VALUES(2,'Moy','sal',300);INSERT INTO tb1 VALUES(3,'Jones','sal',540);INSERT INTO tb1 VALUES(4,'Smith','dev',550);
C1: INSERT INTO tb1 VALUES(5,'Kim','account',380);INSERT INTO tb1 VALUES(6,'Smith','dev',240);INSERT INTO tb1 VALUES(7,'Brown','account',NULL);
C1: CREATE INDEX idx_id on tb1(id);
C1: commit work;

/* test case */
C1: DELETE FROM tb1 WHERE id >5;
MC: wait until C1 ready;

C2: SELECT id,name,'raise' FROM tb1 a WHERE EXISTS( SELECT * FROM tb1 b WHERE b.salary < 250 AND a.id=b.id ) order by 1,2,3;
C2: SELECT id,name,'raise' FROM tb1 a WHERE NOT EXISTS( SELECT * FROM tb1 b WHERE salary < 250) order by 1,2,3;
MC: wait until C2 ready;

C1: commit work;
MC: wait until C1 ready;

C2: select * from tb1 order by id,2,3,4;
C2: commit work;
MC: wait until C2 ready;

C2: quit;
C1: quit;
