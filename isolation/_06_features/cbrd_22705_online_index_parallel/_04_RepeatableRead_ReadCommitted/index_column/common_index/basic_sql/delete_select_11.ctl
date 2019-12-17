/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/delete_select_01.ctl
Author: Lily

Test Point:
changes in current transaction are visible.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id =2;
C2: SELECT * FROM tb1 order by 1,2; 
C1: rollback;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
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

C2: SELECT * FROM tb1 WHERE id>0 ORDER BY id;
MC: wait until C2 ready;

/*MC: wait until C2 ready;*/
C1: rollback;
MC: wait until C1 ready;

C2: commit work;
C2: SELECT * FROM tb1 WHERE id>0 ORDER BY id;
C2: commit work;
MC: wait until C2 ready;

C1: SELECT * FROM tb1 WHERE id>0 ORDER BY id;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
