/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
column of which the function index consisted is nullable.

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
C1: UPDATE tb1 SET col=NULL WHERE id%5=0;
C1: CREATE INDEX idx ON tb1(LEFT(col,1));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 USE INDEX (idx) WHERE LEFT(col,1) =3 AND id <100;
MC: wait until C1 ready;

C2: SELECT * FROM tb1 USE INDEX (idx) WHERE LEFT(col,1) =3 AND id <100 order by 1;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: commit work;
C2: SELECT count(*) FROM tb1 USE INDEX (idx) WHERE LEFT(col,1) =3 and LENGTH(col)=1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

