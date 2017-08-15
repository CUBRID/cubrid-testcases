/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
-    delete: X_LOCK acquired on current instance..
-    select: no row locks acquired but IS_LOCK for table,
             but can see rows before the queries began.
C1 select rows, then delete, finally select.

NUM_CLIENTS = 1
C1: SELECT * FROM tb1 ORDER BY dept_id,name;
C1: DELETE FROM tb1 WHERE name='Jonh';
C1: SELECT * FROM tb1 ORDER BY dept_id,name;
*/

MC: setup NUM_CLIENTS = 1;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(dept_id INT NOT NULL, name VARCHAR(20), sex ENUM('F', 'M') );
C1: INSERT INTO tb1 VALUES(101,'Jonh','M');
C1: INSERT INTO tb1 VALUES(102,'Lucy','F');
C1: INSERT INTO tb1 VALUES(102,'Tom','M');
C1: INSERT INTO tb1 VALUES(101,'Mike','F');
C1: INSERT INTO tb1 VALUES(102,'Jonh','M');
C1: commit work;

MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM tb1 ORDER BY dept_id,name;
MC: wait until C1 ready;
C1: DELETE FROM tb1 WHERE name='Jonh';
C1: SELECT * FROM tb1 ORDER BY dept_id,name;
C1: rollback;

C1: SELECT * FROM tb1 ORDER BY dept_id,name;
MC: wait until C1 ready;
C1: DELETE FROM tb1 WHERE name='Jonh';
C1: commit work;
C1: SELECT * FROM tb1 ORDER BY dept_id,name;
C1: commit work;

C1: quit;
