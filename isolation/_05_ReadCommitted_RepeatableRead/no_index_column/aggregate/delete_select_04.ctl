/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/aggregate/delete_select_01.ctl
Author: Lily

Test Point:
simple min,max, there are unvacuumed data, and uncommitted delete at the same time

NUM_CLIENTS = 3
C1: UPDATE tb1 SET id=id+100000 WHERE mod(id,2)=0;
C2: DELETE FROM tb1 WHERE id=11 or id=23;
C3: SELECT MIN(id),MAX(id) FROM tb1; 
*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT,col VARCHAR(10));
C1: INSERT INTO tb1 SELECT rownum,mod(rownum,100) FROM db_class a,db_class b,db_class c,db_class d where rownum<=10000;
C1: commit;
C1: UPDATE tb1 SET id=id-1,col=col+id;
C1: commit;
MC: sleep 20;
MC: wait until C1 ready;

/* test case */
C1: UPDATE tb1 SET id=id+10000 WHERE mod(id,2)=0;
MC: wait until C1 ready;
C2: DELETE FROM tb1 WHERE id=1 or id=19998;
MC: wait until C2 ready;
C3: SELECT MIN(id),MAX(id) FROM tb1 order by col;
MC: wait until C3 ready;
C2: commit work;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C3: SELECT MIN(id),MAX(id) FROM tb1 order by col;
C3: commit;
/* expected  (3, 19996)*/
C3: SELECT MIN(id),MAX(id) FROM tb1 order by col;
C3: commit;
MC: wait until C3 ready;

C3: quit;
C2: quit;
C1: quit;

