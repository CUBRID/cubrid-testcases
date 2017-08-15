/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
1.select never block delete. 
2.select can not see the committed change made by other transaction whose ID is less current transaction ID.

NUM_CLIENTS = 2
C1: SELECT * FROM tb1 ORDER BY dept_id,name;
C2: DELETE FROM tb1 WHERE name='Jonh'; --rollback and committed
*/
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(dept_id INT NOT NULL, name VARCHAR(20), hire_date DATE, sex ENUM('F', 'M') );
C1: INSERT INTO tb1 VALUES(101,'Jonh','2001-1-26','M');
C1: INSERT INTO tb1 VALUES(102,'Lucy','2002-4-12','F');
C1: INSERT INTO tb1 VALUES(102,'Tom','2002-2-18','M');
C1: INSERT INTO tb1 VALUES(101,'Mike','2005-9-26','F');
C1: INSERT INTO tb1 VALUES(102,'Jonh','2004-5-5','M');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM tb1 ORDER BY dept_id,name;
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE name='Jonh';
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
C2: commit work;
MC: wait until C2 ready;
C1: SELECT * FROM tb1 ORDER BY dept_id,name;
C1: commit work;
MC: wait until C1 ready;

C2: DELETE FROM tb1 WHERE name='Mike';
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
C2: rollback;
MC: wait until C2 ready;
C1: SELECT * FROM tb1 ORDER BY dept_id,name;

C1: commit;
C2: quit;
C1: quit;
