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

[CUBRIDQA-1391] Since CBRD-26747, fixed scan is enabled by default, causing latch to be held.
during query execution and distorting intended concurrent behavior in this TC.
Disable enable_heap_fixed_scan temporarily. See CUBRIDQA-1391 for details.
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C1: set system parameters 'enable_heap_fixed_scan=false';

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: set system parameters 'enable_heap_fixed_scan=false';

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
C1: SELECT tb1.* FROM tb1 WHERE (SELECT SLEEP(1)=0)<>0 ORDER BY dept_id,name;
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

C2: set system parameters 'enable_heap_fixed_scan=true';
C1: set system parameters 'enable_heap_fixed_scan=true';
C2: quit;
C1: quit;
