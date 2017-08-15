/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
changes in current transaction can be seen.

NUM_CLIENTS = 2
C1: DELETE FROM tb1; 
C2: DELETE FROM tb1;
C1: commit;
C1: DELETE FROM tb1;
C2: SELECT FROM tb1;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, col VARCHAR(10));
C1: INSERT INTO tb1 SELECT rownum,mod(rownum,100) FROM db_class a,db_class b where rownum<=500;
C1: UPDATE tb1 SET col=NULL WHERE col in ('1','10','50','99');
C1: CREATE UNIQUE INDEX idx_1 ON tb1(id);
C1: CREATE INDEX idx_2 ON tb1(col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id between 51 and 90;
C1: commit work;
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE col IS NULL;
MC: wait until C2 ready;
C1: DELETE FROM tb1 WHERE id >180 and id<199;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 WHERE id>80 AND id <100 order by id;
C2: SELECT * FROM tb1 WHERE id>180 AND id <200 order by id;
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
C2: commit work;
C2: SELECT * FROM tb1 WHERE id>80 AND id <100 order by id;
C2: SELECT * FROM tb1 WHERE id>180 AND id <200 order by id;
C2: SELECT COUNT(*) FROM tb1 ORDER BY id;
C2: commit;
C2: quit;
C1: quit;
