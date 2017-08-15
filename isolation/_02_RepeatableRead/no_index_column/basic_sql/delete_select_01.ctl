/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
1.delete do not block select.
2.select will see the same resultset before and after other transaction committed.
3.delete transaction ID is smaller than select transaction ID.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE name='Jonh'; --rollback and committed
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
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
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE name='Jonh';
MC: wait until C1 ready;
/* see all 5 rows */
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
MC: wait until C2 ready;
C1: commit;
/* see all 5 rows */
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
C2: commit work;
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
C2: commit work;
MC: wait until C2 ready;

C1: DELETE FROM tb1 WHERE sex='M';
MC: wait until C1 ready;
/* see 3 rows */
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
MC: wait until C2 ready;
C1: rollback;
MC: wait until C1 ready;
/* see 3 rows */
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
C2: commit work;
/* see 2 rows */
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
C2: commit;
C2: quit;
C1: quit;
