/*
Test Case: delete & select
Priority: 1
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/delete_select_07.ctl
Author: Lily

Test Point:
-    delete: X_LOCK acquired on current instance..
-    select: no row locks acquired but IS_LOCK for table,
             but can see rows before the queries began.
C1 delete rows, C2 select rows, overlapped.
Primary key is a multiple-column index.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE name='Jonh'; --rollback
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(dept_id INT NOT NULL, name VARCHAR(20), hire_date DATE, sex ENUM('F', 'M'),CONSTRAINT pk_id PRIMARY KEY (dept_id ,name) );
C1: INSERT INTO tb1 VALUES(101,'Jonh','2001-1-26','M');
C1: INSERT INTO tb1 VALUES(102,'Lucy','2002-4-12','F');
C1: INSERT INTO tb1 VALUES(102,'Tom','2002-2-18','M');
C1: INSERT INTO tb1 VALUES(101,'Mike','2005-9-26','F');
C1: INSERT INTO tb1 VALUES(102,'Jonh','2004-5-5','M');
C1: INSERT INTO tb1 VALUES(101,'Susan','2003-8-13','F');
C1: INSERT INTO tb1 VALUES(101,'Elena','2006-6-13','F');
C1: INSERT INTO tb1 VALUES(101,'Jack','2002-6-13','M');
C1: commit work;

MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE name='Jonh';
MC: wait until C1 ready;
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
MC: wait until C2 ready;
C1: rollback;
C2: SELECT * FROM tb1 ORDER BY dept_id,name;
C2: commit work;

C2: quit;
C1: quit;
