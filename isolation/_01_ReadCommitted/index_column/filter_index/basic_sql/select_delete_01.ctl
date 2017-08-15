/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
1. Reading queries can only have a look at data committed before the queries began
2. Uncommitted data or changes committed after the query started are never seen

NUM_CLIENTS = 2 
C1: select * from tb1 order by 1,2;
   C2: delete from tb1; 
   C2: commit;
C1: commit;
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
C1: INSERT INTO tb1 SELECT (@newincr:=@newincr+1),(@newincr)%50 FROM db_class a,db_class b,db_class c limit 1000;
C1: CREATE INDEX idx ON tb1(col) WHERE col=1;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT tb1.* FROM (select sleep(1)) x, tb1 WHERE col=1 USING INDEX idx(+) order by id;
C2: DELETE FROM tb1 WHERE col=1;
MC: wait until C2 ready;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C1: commit work;
C1: SELECT * FROM tb1 WHERE col=1;
C1: commit;

C2: quit;
C1: quit;

