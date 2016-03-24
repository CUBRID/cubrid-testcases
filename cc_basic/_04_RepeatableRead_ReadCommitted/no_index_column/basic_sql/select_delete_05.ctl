/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
-    delete: X_LOCK acquired on current instance..
-    select: no row locks acquired but IS_LOCK for table,
C1 read 20,000 data, C2(delete) begin after C1 begin,C2 commit before C1 end 

NUM_CLIENTS = 2
C1: SELECT * FROM tb1 WHERE id < 100;
C2: DELETE FROM tb1 WHERE id = 2;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(a VARCHAR(1500),id INT );
C1: INSERT INTO tb1(a,id) SELECT RPAD('1', 1024, '1'), rownum FROM db_class a, db_class b, db_class c, db_class d WHERE rownum <= 20000;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: SELECT id  FROM tb1 WHERE id < 40 order by id;
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE id=2;
MC: wait until C2 ready;
C2: commit;
MC: wait until C1 ready;
C1: SELECT id  FROM tb1 WHERE id < 40 order by id;
C1: commit;
C1: SELECT id  FROM tb1 WHERE id < 40 order by id;
C1: commit;
MC: wait until C2 ready;


C2: quit;
C1: quit;
