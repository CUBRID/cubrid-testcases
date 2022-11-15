/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/delete_select_01.ctl
Author: Lily

Test Point:
C1 delete rows, C2 select rows, overlapped.
delete and select use same index.
transactions are not blocked.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id <= 3;
C2: select * from tb1 order by id; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, col VARCHAR(10) );
C1: INSERT INTO tb1 SELECT rownum,rownum%100 FROM db_class a,db_class b LIMIT 500;
C1: CREATE INDEX idx_id on tb1(col);
C1: CREATE INDEX idx_col on tb1(id);
C1: update statistics on tb1;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE col = '2';
MC: wait until C1 ready;
C2: SELECT * FROM tb1 WHERE col = '2' ORDER BY id;
C2: drop index idx_col on tb1;
MC: wait until C2 blocked;
C1: SELECT * FROM tb1 WHERE col in ('2','3') ORDER BY id;
C1: commit work;

MC: wait until C2 ready;
C2: update statistics on tb1 with fullscan;
C2: show index from tb1;
C2: SELECT * FROM tb1 WHERE col in ('2','3') ORDER BY id;
C2: commit work;
MC: wait until C1 ready;
C2: SELECT COUNT(*) FROM tb1;
C2: commit work;
MC: wait until C2 ready;
C1: update statistics on tb1;
C1: show index from tb1;
C1: CREATE INDEX idx_col on tb1(id);
C1: select * from db_index where class_name='tb1';
C1: commit work;

C2: quit;
C1: quit;
