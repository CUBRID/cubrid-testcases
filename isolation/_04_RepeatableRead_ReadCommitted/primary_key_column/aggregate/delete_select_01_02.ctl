/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/aggregate/delete_select_01.ctl
Author: Lily

Test Point:
there is expr in sum, there are unvacuumed data, and uncommitted delete at the same time
C1 delete begin
                      C2 select sum() begin
                      C2 commit
C1 commit

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE mod(id,5)=0;
C2: SELECT SUM(id)/20>id+col+8 FROM tb1 GROUP BY col; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10));
C1: INSERT INTO tb1 SELECT rownum,rownum%20 FROM db_class a,db_class b,db_class c,db_class d where rownum <= 100000;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE mod(id,5)=0;
MC: wait until C1 ready;
C2: SELECT SUM(id)/100>id+col+500000 FROM tb1 GROUP BY col;
C2: commit;
C2: SELECT SUM(id)/100>id+col+500000 FROM tb1 GROUP BY col;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: SELECT SUM(id)/100>id+col+500000 FROM tb1 GROUP BY col;
C2: commit;

C2: quit;
C1: quit;

