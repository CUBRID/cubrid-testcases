/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/aggregate/delete_select_01.ctl
Author: Lily

Test Point:
simple min,max, there are unvacuumed data, and uncommitted delete at the same time
C1 delete begin
                      C2 select begin
                      C2 commit
C1 commit

NUM_CLIENTS = 3
C1: UPDATE tb1 SET id=id+100000 WHERE id%2=0;
C2: DELETE FROM tb1 WHERE id=11 or id=23;
C3: SELECT MIN(id),MAX(id) FROM tb1; 
*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id BIGINT PRIMARY KEY,col VARCHAR(10));
C1: set @newincr=0;
C1: INSERT INTO tb1 SELECT (@newincr:=@newincr+1),(@newincr)%100 FROM db_class a,db_class b,db_class c,db_class d LIMIT 10;
C1: commit;
C1: UPDATE tb1 SET id=id-1,col=col+id;
MC: sleep 10;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: UPDATE tb1 SET id=id+10 WHERE id%2=0 and (select sleep(10)=0);
/*MC: wait until C1 ready;*/
MC: sleep 1;

C2: DELETE FROM tb1 WHERE id=1 or id=18 and (select sleep(5)=0);
MC: sleep 1;

/* expected (0,99999) */ 
C3: SELECT MIN(id),MAX(id) FROM tb1;
MC: wait until C3 ready;
C1: commit work;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
/* expected  (3, 199998)*/
C2: SELECT MIN(id),MAX(id) FROM tb1;
C3: quit;
C2: quit;
C1: quit;

