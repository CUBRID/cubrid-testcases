/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
delete a lot of filtered index value. 

NUM_CLIENTS = 2
C1: delete from tb1; 
C2: select * from tb1 order by 1,2;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id BIGINT NOT NULL,col VARCHAR(10));
C1: set @newincr=0;
C1: INSERT INTO tb1 SELECT (@newincr:=@newincr+1),(@newincr)%50 FROM db_class a,db_class b,db_class c,db_class d limit 100000;
C1: CREATE INDEX idx ON tb1(id) WHERE id%4=0;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 USE INDEX (idx) WHERE id%8=0;
MC: wait until C1 ready;

C2: SELECT count(id) FROM tb1 USE INDEX (idx) WHERE id%8=0 ;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: commit work;
MC: wait until C2 ready;

C2: SELECT * from tb1 WHERE id%8=0;
C2: SELECT count(*) FROM tb1 ORDER BY id;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

