/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
C1 delete rows, C2 select rows, overlapped.
delete and select use different index.
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
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id <= 3;
C1: DELETE FROM tb1 WHERE id between 20 and 51;
C1: delete from tb1 where col in ('2','9','10');
MC: wait until C1 ready;
C2: SELECT tb1.* FROM (select sleep(2)) x, tb1 WHERE col='2' ORDER BY id;
MC: sleep 1;
C1: commit work;
MC: wait until C1 ready;
/* expect 500 */
C2: SELECT COUNT(*) FROM tb1;
C2: commit work;
C2: SELECT COUNT(*) FROM tb1;
C2: commit work;

C2: quit;
C1: quit;
