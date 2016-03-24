/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
Index skip scan.

NUM_CLIENTS = 2
C1: DELETE FROM tb1;
C3: SELECT * FROM tb1 ORDER BY id;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
MC: wait until C2 ready;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT,col VARCHAR(10));
C1: INSERT INTO tb1 SELECT mod(rownum,100),rownum FROM db_class a,db_class b,db_class c where rownum<=10000;
C1: UPDATE tb1 SET col=col+'aa' WHERE cast(col as int)<=100;
C1: ALTER TABLE tb1 ADD PRIMARY KEY (id,col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE col LIKE '10_';
C1: select * from tb1 where id between 1 and 10 and col like '20_';
MC: sleep 1;
C2: SELECT * FROM tb1 WHERE col LIKE '999%' order by id;
C2: delete from tb1 where id=50;
C2: SELECT * FROM tb1 WHERE col LIKE '10_' order by id;
MC: wait until C2 ready;
C1: commit work;
C2: SELECT * FROM tb1 WHERE col LIKE '10_' order by id; 
C2: commit;
C2: select count(*) from tb1;
C2: commit;
C2: quit;
C1: quit;
