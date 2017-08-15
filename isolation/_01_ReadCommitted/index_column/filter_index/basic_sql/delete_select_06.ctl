/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
delete and select data not overlapped.
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
C1: CREATE TABLE tb1(id BIGINT NOT NULL,col INT);
C1: set @newincr=0;
C1: INSERT INTO tb1 SELECT (@newincr:=@newincr+1)%5,(@newincr)%50000 FROM db_class a,db_class b,db_class c,db_class d limit 100000;
C1: CREATE INDEX idx ON tb1(id,col) WHERE id <3 AND col<2500;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE col<10 AND id=2;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 WHERE col<10 AND id=1 order by 1,2;
MC: wait until C2 ready;
C1: commit;
C2: commit work;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: select * FROM tb1 WHERE col<10 AND id=2 order by 1,2;
C2: SELECT count(*) FROM tb1 ORDER BY id;
C2: commit;

C2: quit;
C1: quit;

