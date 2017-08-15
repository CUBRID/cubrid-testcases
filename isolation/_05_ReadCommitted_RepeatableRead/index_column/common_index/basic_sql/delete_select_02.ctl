/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/delete_select_01.ctl
Author: Lily

Test Point:
C1 delete rows, C2 select rows, overlapped.
transactions are not blocked.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id <= 3;
C2: select * from tb1 order by id; 
C1: rollback
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, col VARCHAR(10) );
C1: INSERT INTO tb1 SELECT rownum,mod(rownum,100) FROM db_class a,db_class b where rownum<=500;
C1: CREATE INDEX idx_id on tb1(col);
C1: CREATE INDEX idx_col on tb1(id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id <= 10;
C1: commit;
C1: DELETE FROM tb1 WHERE id between 20 and 51;
C1: delete from tb1 where col in ('2','9','10');
MC: wait until C1 ready;
C2: SELECT * FROM tb1 WHERE col='2' ORDER BY id;
MC: wait until C2 ready;
C1: SELECT * FROM tb1 WHERE id <= 3;
C1: rollback;
/* expect 500 */
C1: SELECT COUNT(*) FROM tb1;
C1: commit work;
MC: wait until C1 ready;
C2: SELECT COUNT(*) FROM tb1;
C2: commit work;
C2: quit;
C1: quit;
