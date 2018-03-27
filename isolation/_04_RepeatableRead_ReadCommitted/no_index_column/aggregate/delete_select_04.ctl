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
C1: UPDATE tb1 SET id=id+100000 WHERE mod(id,2)=0;
C2: DELETE FROM tb1 WHERE id=11 or id=23;
C3: SELECT MIN(id),MAX(id) FROM tb1; 
*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;
/* preparation */
C1: drop table if exists tb1;
C1: CREATE TABLE tb1(id INT,col VARCHAR(10));
C1: INSERT INTO tb1 SELECT rownum,rownum%100 FROM db_class a,db_class b,db_class c,db_class d where rownum <= 100000;
C1: commit;
C1: UPDATE tb1 SET id=id-1,col=col+id;
C1: commit;
MC: sleep 30;
MC: wait until C1 ready;

/* test case */
C1: UPDATE tb1 SET id=id+100000 WHERE mod(id,2)=0;
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE id=1 or id=199998;
MC: wait until C2 ready;
/* expected (1,199998) */ 
C3: SELECT MIN(id),MAX(id) FROM tb1;
MC: wait until C3 ready;
C1: commit;
MC: wait until C1 ready;
/* expected  (3, 199996)*/
C3: SELECT MIN(id),MAX(id) FROM tb1;
MC: wait until C3 ready;
C2: commit;
MC: wait until C2 ready;
C3: SELECT MIN(id),MAX(id) FROM tb1;
C3: commit;
MC: wait until C3 ready;

C2: quit;
C1: quit;
C3: quit;

