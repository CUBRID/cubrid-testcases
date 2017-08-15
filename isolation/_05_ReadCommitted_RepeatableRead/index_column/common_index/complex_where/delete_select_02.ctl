/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
there is between keyword in select statement.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id <= 3;
C2: select * from tb1 order by id; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, name VARCHAR(10),job VARCHAR(10),salary INT );
C1: INSERT INTO tb1 VALUES(1,'Kim','dev',400);INSERT INTO tb1 VALUES(2,'Moy','sal',300);INSERT INTO tb1 VALUES(3,'Jones','sal',540);INSERT INTO tb1 VALUES(4,'Smith','dev',550);
C1: INSERT INTO tb1 VALUES(5,'Kim','account',380);INSERT INTO tb1 VALUES(6,'Smith','dev',240);INSERT INTO tb1 VALUES(7,'Brown','account',NULL);
C1: CREATE INDEX idx_id on tb1(salary);
C1: commit work;

/* test case */
C1: DELETE FROM tb1 WHERE id <= 3;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 WHERE salary BETWEEN 300 AND 400;
C2: SELECT * FROM tb1 WHERE salary NOT BETWEEN 300 AND 400;
MC: wait until C2 ready;
C1: commit;
C1: DELETE FROM tb1 WHERE id=7;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 WHERE name BETWEEN 'A' AND 'E';
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 ORDER BY id;
C2: commit work;

C2: quit;
C1: quit;
