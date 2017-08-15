/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
changes committed after the query started are never seen

NUM_CLIENTS = 2
C1: SELECT * FROM tb1 WHERE sleep(1,name)=1 ORDER BY dept_id,name;
C2: DELETE FROM tb1 WHERE name='Jonh'; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(dept_id INT NOT NULL, name VARCHAR(20),sex ENUM('F', 'M') );
C1: INSERT INTO tb1 VALUES(101,'Jonh','M');
C1: INSERT INTO tb1 VALUES(102,'Lucy','F');
C1: INSERT INTO tb1 VALUES(102,'Tom','M');
C1: INSERT INTO tb1 VALUES(101,'Mike','F');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT tb1.* FROM (select sleep(1)) x, tb1 ORDER BY dept_id,name;
/*MC: wait until C1 ready;*/
C2: DELETE FROM tb1 WHERE name='Jonh';
C2: INSERT INTO tb1 VALUES(101,'Kite','M');
C2: commit;
MC: wait until C2 ready;
MC: wait until C1 ready;

C1: SELECT * FROM tb1 ORDER BY dept_id,name;
C1: commit work;
C1: SELECT * FROM tb1 ORDER BY dept_id,name;
MC: wait until C1 ready;

C2: quit;
C1: quit;
