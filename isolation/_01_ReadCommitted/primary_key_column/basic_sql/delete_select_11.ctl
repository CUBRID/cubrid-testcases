/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
delete lot of records.

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
C1: CREATE TABLE tb1(id BIGINT NOT NULL PRIMARY KEY,col VARCHAR(10));
C1: set @newincr=0;
C1: INSERT INTO tb1 SELECT (@newincr:=@newincr+1),(@newincr)%50 FROM db_class a,db_class b,db_class c limit 1000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id%50=0 AND (select sleep(2))=0;
MC: sleep 1;
C2: SELECT * FROM tb1 WHERE id%100=0 order by id;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit work;
C2: select * from tb1 WHERE id%20=0 order by id;
C2: SELECT COUNT(*) FROM tb1 ORDER BY id;
C2: commit;

C2: quit;
C1: quit;

