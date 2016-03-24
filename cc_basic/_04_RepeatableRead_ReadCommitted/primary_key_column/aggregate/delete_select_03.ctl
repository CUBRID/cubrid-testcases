/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/aggregate/delete_select_01.ctl
Author: Lily

Test Point:
simple count, there are unvacuumed data, and uncommitted delete at the same time
C1 delete begin
                      C2 select count() begin
                      C2 commit
C1 commit

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE mod(id,5)=0;
C2: SELECT COUNT(id) FROM tb1; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10));
C1: INSERT INTO tb1 SELECT rownum,rownum%100 FROM db_class a,db_class b,db_class c,db_class d where rownum <= 10000;
C1: commit;
C1: UPDATE tb1 SET id=id-1,col=col+id;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE mod(id,5)=0;
MC: wait until C1 ready;
/* expected 100000  */ 
C2: SELECT COUNT(id) FROM tb1;
C2: commit;
C2: SELECT COUNT(id) FROM tb1;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
/* expected 80000 */
C2: SELECT COUNT(id) FROM tb1;
C2: commit;
C2: quit;
C1: quit;

