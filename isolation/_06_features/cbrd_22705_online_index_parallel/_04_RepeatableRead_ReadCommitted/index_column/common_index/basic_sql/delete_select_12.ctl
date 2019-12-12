/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
Reading queries can only have a look at data committed before the queries began.
changes committed after the query started are never seen.

NUM_CLIENTS = 4
C1: DELETE FROM tb1 WHERE id =2;
C2: DELETE FROM tb1 WHERE id =6;
C3: INSERT INTO tb1 VALUES(2,'care');
C4: SELECT * FROM tb1 order by 1,2; 
C1: commit work;
C2: rollback;
C3: commit work;
C4: SELECT * FROM tb1 order by 1,2;
*/

MC: setup NUM_CLIENTS = 4;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level read committed;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, col VARCHAR(10) );
C1: CREATE INDEX idx_id on tb1(col) with online parallel 3;
C1: CREATE INDEX idx_col on tb1(id) with online parallel 3;
C1: INSERT INTO tb1 VALUES(1,'do');INSERT INTO tb1 VALUES(2,'make');INSERT INTO tb1 VALUES(3,'spell');INSERT INTO tb1 VALUES(4,'have');INSERT INTO tb1 VALUES(6,'be');INSERT INTO tb1 VALUES(8,'run');INSERT INTO tb1 VALUES(9,'keep');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id =2;
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE id =6;
MC: wait until C2 ready;
C3: INSERT INTO tb1 VALUES(2,'care');
MC: wait until C3 ready;
C4: SELECT * FROM tb1 WHERE id>0 ORDER BY id;
MC: wait until C4 ready;
/*MC: wait until C2 ready;
MC: wait until C3 ready;
MC: wait until C4 ready;*/

C1: commit work;
MC: wait until C1 ready;
C4: SELECT * FROM tb1 WHERE id>0 ORDER BY id;
MC: wait until C4 ready;
C3: INSERT INTO tb1 VALUES(6,'sing');
MC: wait until C3 ready;
C2: rollback;
MC: wait until C2 ready;
C3: commit work;
MC: wait until C3 ready;
C4: SELECT * FROM tb1 WHERE id>0 ORDER BY id;
C4: commit work;
MC: wait until C4 ready;

C1: quit;
C2: quit;
C3: quit;
C4: quit;
