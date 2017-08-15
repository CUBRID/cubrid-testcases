/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
simple group_concat, there are unvacuumed data, and uncommitted delete at the same time

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id=3;
C2: SELECT YEAR(hire_date), GROUP_CONCAT(name ORDER BY name SEPARATOR ':') FROM tb1 GROUP BY YEAR(hire_date); 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id BIGINT,name VARCHAR(20),hire_date DATE,sex ENUM('F','M'));
C1: INSERT INTO tb1 VALUES(1,'Jonh','2001-1-26','M');
C1: INSERT INTO tb1 VALUES(5,'Lucy','2002-4-12','F');
C1: INSERT INTO tb1 VALUES(3,'Tom','2002-2-18','M');
C1: INSERT INTO tb1 VALUES(1,'Mike','2001-9-26','F');
C1: INSERT INTO tb1 VALUES(5,'Jonh','2003-5-5','M');
C1: INSERT INTO tb1 VALUES(3,'Susan','2003-8-13','F');
C1: INSERT INTO tb1 VALUES(3,'Elena','2002-6-13','F');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id=3;
MC: wait until C1 ready;
C2: SELECT YEAR(hire_date), GROUP_CONCAT(name ORDER BY name SEPARATOR ':') FROM tb1 GROUP BY YEAR(hire_date);
MC: wait until C2 ready;
C1: rollback;
MC: wait until C1 ready;
C2: SELECT YEAR(hire_date), GROUP_CONCAT(name ORDER BY name SEPARATOR ':') FROM tb1 GROUP BY YEAR(hire_date);
C2: commit work;
C2: SELECT YEAR(hire_date), GROUP_CONCAT(name ORDER BY name SEPARATOR ':') FROM tb1 GROUP BY YEAR(hire_date);
C2: commit work;

C1: DELETE FROM tb1 WHERE id=3;
MC: wait until C1 ready;
C2: SELECT YEAR(hire_date), GROUP_CONCAT(name ORDER BY name SEPARATOR ':') FROM tb1 GROUP BY YEAR(hire_date);
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: SELECT YEAR(hire_date), GROUP_CONCAT(name ORDER BY name SEPARATOR ':') FROM tb1 GROUP BY YEAR(hire_date);
C2: commit work;
C2: SELECT YEAR(hire_date), GROUP_CONCAT(name ORDER BY name SEPARATOR ':') FROM tb1 GROUP BY YEAR(hire_date);
C2: commit work;

C2: quit;
C1: quit;

