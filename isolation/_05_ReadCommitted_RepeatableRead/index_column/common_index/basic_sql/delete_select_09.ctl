/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/delete_select_01.ctl
Author: Lily

Test Point:
can see the change made by transaction whose ID is smaller than current transaction's and which is committed.

*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, col VARCHAR(10) );
C1: CREATE INDEX idx_id on tb1(id);
C1: INSERT INTO tb1 VALUES(1,'do');INSERT INTO tb1 VALUES(2,'make');INSERT INTO tb1 VALUES(3,'spell');INSERT INTO tb1 VALUES(4,'have');INSERT INTO tb1 VALUES(6,'be');INSERT INTO tb1 VALUES(8,'run');INSERT INTO tb1 VALUES(9,'keep');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: CREATE INDEX idx_col on tb1(col);
C1: DELETE FROM tb1 WHERE id =2;
C1: commit work;
MC: wait until C1 ready;
C2: drop index idx_col on tb1;
C2: DELETE FROM tb1 WHERE id =8;
C2: select * from db_index where class_name='tb1';
C2: rollback;
C3: drop index idx_col on tb1;
C3: insert into tb1 values(2,'make');
C3: CREATE INDEX idx_col on tb1(col);
C3: select * from db_index where class_name='tb1';
C3: commit;
MC: wait until C3 ready; 
C2: SELECT * FROM tb1 WHERE id>0 ORDER BY id;
C2: commit work;
MC: wait until C2 ready; 
C1: SELECT * FROM tb1 WHERE id>0 ORDER BY id;
C1: commit;
C1: quit;
C2: quit;
