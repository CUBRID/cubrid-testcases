/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
create, drop index in different client.
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
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id <= 3;
C1: DELETE FROM tb1 WHERE id between 20 and 51;
C1: delete from tb1 where col in ('2','9','10');
MC: wait until C1 ready;
C2: ALTER TABLE tb1 ADD CONSTRAINT pk_tb1_id PRIMARY KEY(id);
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: insert into tb1 values(2,'test');
C2: commit;
C2: insert into tb1 values(9,'test');
MC: wait until C2 ready;
C1: SELECT COUNT(*) FROM tb1 where id<100;
C1: update tb1 set id=id+500,col='updated' where id in ('2','9','10');
MC: wait until C1 ready;
C2: SELECT COUNT(*) FROM tb1 where id <100;
C2: ALTER TABLE tb1 DROP PRIMARY KEY;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: show index from tb1;
C2: commit;
MC: wait until C2 ready;
C1: ALTER TABLE tb1 ADD CONSTRAINT pk_tb1_id PRIMARY KEY(id);
C1: select * from db_index where class_name='tb1';
C1: select count(*) from tb1 where id=2;
C1: DELETE FROM tb1 WHERE id between 120 and 151;
MC: wait until C1 ready;
C2: SELECT COUNT(*) FROM tb1 where id <200;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: commit;
MC: wait until C1 ready;
C2: SELECT COUNT(*) FROM tb1 where id<200;
C2: commit;
C2: quit;
C1: quit;

