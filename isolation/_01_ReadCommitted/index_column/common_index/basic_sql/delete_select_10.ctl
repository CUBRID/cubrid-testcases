/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/delete_select_01.ctl
Author: Lily

Test Point:
changes in current transaction are visible.
committed changes are visible.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id =2;
C2: SELECT * FROM tb1 order by 1,2; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, col VARCHAR(10) );
C1: CREATE INDEX idx_id on tb1(col);
C1: CREATE INDEX idx_col on tb1(id);
C1: INSERT INTO tb1 VALUES(1,'do'),(2,'make'),(3,'spell'),(4,'have'),(6,'be'),(8,'run'),(9,'keep');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id =2;
MC: wait until C1 ready;

C2: SELECT * FROM tb1 WHERE id>0 ORDER BY id;
MC: wait until C2 ready;

/*MC: wait until C2 ready;*/
C1: SELECT * FROM tb1 WHERE id>0 ORDER BY id;
MC: wait until C1 ready;

C2: commit work;
MC: wait until C2 ready;

C1: SELECT * FROM tb1 WHERE id>0 ORDER BY id;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
