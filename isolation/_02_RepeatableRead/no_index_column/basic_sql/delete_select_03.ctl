/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
1. can see uncommitted change in current transaction.
2. other transaction can not see uncommitted and committed change made by other transaction.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE name='Tom'; --rollback and committed
C1: SELECT * FROM tb1 ORDER BY dept_id,name;
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
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
C1: DELETE FROM tb1 WHERE name='Tom';
/* expect 4 rows */
C1: SELECT * FROM tb1 ORDER BY dept_id,name;
MC: wait until C1 ready;
/* expect 5 rows */
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
/* expect 5 rows */
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
C2: commit work;
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
C2: commit work;
MC: wait until C2 ready;

C1: DELETE FROM tb1 WHERE sex='M';
C1: SELECT * FROM tb1 ORDER BY dept_id,name;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
MC: wait until C2 ready;
C1: rollback;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
C2: commit work;
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
C2: commit work;

C2: quit;
C1: quit;
