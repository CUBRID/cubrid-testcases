/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
select lot of rows;

NUM_CLIENTS = 2
C2: select * from tb1 order by 1,2;
C1: delete from tb1; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id BIGINT NOT NULL,col INT, PRIMARY KEY (id,col));
C1: set @newincr=0;
C1: INSERT INTO tb1 SELECT (@newincr:=@newincr+1),(@newincr)%1000 FROM db_class a,db_class b,db_class c limit 10000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT tb1.* FROM (select sleep(1)) x,tb1 WHERE col>20 AND col<25 order by id;
MC: sleep 2;
C2: DELETE FROM tb1 WHERE col>15 AND col< 23;
C2: SELECT count(*) FROM tb1 WHERE col>20 AND col<28;
MC: wait until C2 ready;
C2: commit work;
MC: wait until C1 ready;
C2: commit;
C2: SELECT count(*) FROM tb1 WHERE col<30;

C2: quit;
C1: quit;

