/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/delete_select_01.ctl
Author: Lily

Test Point:
changes in current transaction are visible.

NUM_CLIENTS = 1
C1: DELETE FROM tb1 WHERE id =2;
C1: DELETE FROM tb1 WHERE col ='have';
C1: DELETE FROM tb1 WHERE id =8;
C1: DELETE FROM tb1 WHERE col ='keep';
C1: select * from tb1 order by id;  -- all deleted data are invisible
C1: rollback;
C1: select * from tb1 order by id;  -- all date are visible
*/

MC: setup NUM_CLIENTS = 1;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

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
C1: DELETE FROM tb1 WHERE col ='have';
C1: DELETE FROM tb1 WHERE id =8;
C1: DELETE FROM tb1 WHERE col ='keep';
C1: SELECT * FROM tb1 WHERE id>0 ORDER BY id;
C1: rollback;
C1: SELECT * FROM tb1 WHERE id>0 ORDER BY id;
C1: commit work;

C1: quit;
