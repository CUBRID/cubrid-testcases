/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
there are IS NULL keyword in select statement.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id <= 3;
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
C1: CREATE TABLE tb1( id INT, name VARCHAR(10),job VARCHAR(10),salary INT );
C1: INSERT INTO tb1 VALUES(1,'Kim','dev',400);INSERT INTO tb1 VALUES(2,'Moy','sal',300);INSERT INTO tb1 VALUES(3,'Jones','sal',540);INSERT INTO tb1 VALUES(4,'Smith','dev',550);
C1: INSERT INTO tb1 VALUES(5,'Kim','account',380);INSERT INTO tb1 VALUES(6,'Smith','dev',240);INSERT INTO tb1 VALUES(7,'Brown','account',NULL);
C1: CREATE INDEX idx_id on tb1(id) with online parallel 3;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id <= 3;
MC: wait until C1 ready;

C2: SELECT * FROM tb1 WHERE salary IS NOT NULL AND job IN ('sal','account') ORDER BY id;  
MC: wait until C2 ready;

C1: rollback;
MC: wait until C1 ready;

C2: SELECT * FROM tb1 WHERE salary IS NOT NULL AND job IN ('sal','account') ORDER BY id; 
C2: commit work;
MC: wait until C2 ready;

C2: quit;
C1: quit;
