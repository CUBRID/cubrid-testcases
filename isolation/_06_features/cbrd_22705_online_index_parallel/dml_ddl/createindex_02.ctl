/*
Test Case: create index & drop index
Priority: 1
Reference case:
Author: Lily

Test Point:
C1 create index, C2 drop index or alter index.

*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb_b;
C1: DROP TABLE IF EXISTS tb_a;
C1: CREATE TABLE tb_a( id INT, col VARCHAR(10));
C1: CREATE TABLE tb_b( id INT, col VARCHAR(10));
C1: INSERT INTO tb_a SELECT rownum,rownum%200 FROM db_class a,db_class b,db_class c,db_class d limit 50000;
C1: INSERT INTO tb_b SELECT rownum,rownum%200 FROM db_class a,db_class b,db_class c,db_class d limit 50000;
C1: update tb_a set id =50000+id where col in ('1','5','10','25','50','90','100','150');
C1: update tb_b set id =50000+id where col in ('1','5','10','25','50','90','100','150');
C1: commit;
MC: wait until C1 ready;

/* test case 1 */
C1: CREATE INDEX idx1 on tb_a(id,col) with online parallel 3;
C1: CREATE INDEX idx2 on tb_b(id,col) with online parallel 3;
C1: SELECT * FROM db_index  where class_name like 'tb_%';
C1: insert into tb_b values(5,'run'),(100,'test'),(25,'com');
MC: wait until C1 ready;
C2: CREATE INDEX idx1 on tb_a(id) with online parallel 3;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: rollback;

C2: DROP INDEX idx1 on tb_a;
C2: DROP INDEX idx2 on tb_b;
C2: SELECT * FROM db_index where class_name like 'tb_%';
C2: CREATE INDEX idx1 on tb_a(id) with online parallel 3;
MC: wait until C2 ready;
C1: CREATE INDEX idx_id on tb_a(id) with online parallel 3;
MC: wait until C1 blocked;
C2: commit;
MC: wait until C1 ready;
C1: DROP INDEX idx1 on tb_a; 
MC: sleep 1;
C1: CREATE INDEX idx_id on tb_a(id) with online parallel 3;
C1: commit;
MC: wait until C1 ready;

C2: SELECT * FROM db_index where class_name like 'tb_%';
C2: DROP INDEX idx_id on tb_a; 
C2: CREATE INDEX idx1 on tb_a(id,col) with online parallel 3;
C2: CREATE INDEX idx2 on tb_b(id,col) with online parallel 3;
MC: wait until C1 ready;
C1: SELECT * FROM db_index where class_name like 'tb_%';
C1: CREATE INDEX idx1 on tb_a(id,col) with online parallel 3;
MC: wait until C1 blocked;
C2: rollback;
MC: wait until C1 ready;
C1: SELECT * FROM db_index where class_name like 'tb_%';
C1: commit;

C2: quit;
C1: quit;
