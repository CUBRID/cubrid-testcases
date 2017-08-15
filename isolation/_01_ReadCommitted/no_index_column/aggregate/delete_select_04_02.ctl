/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/aggregate/delete_select_01.ctl
Author: Lily

Test Point:
there is expr in max and min, there are unvacuumed data, and uncommitted delete at the same time
C1 delete begin
                      C2 select begin
                      C2 commit
C1 commit

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id%5=0;
C2: SELECT MAX(id)-MIN(id)>19 FROM tb1 GROUP BY col; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id BIGINT,col VARCHAR(10));
C1: set @newincr=0;
C1: INSERT INTO tb1 SELECT (@newincr:=@newincr+1),(@newincr)%20 FROM db_class a,db_class b,db_class c,db_class d LIMIT 100000;
C1: commit;
MC: sleep 6;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id%5=0;
MC: wait until C1 ready;
C2: SELECT MAX(id)-MIN(id)>19 FROM tb1 GROUP BY col;
C2: commit work;
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
C2: SELECT MAX(id)-MIN(id)>19 FROM tb1 GROUP BY col;
C2: commit work;

C2: quit;
C1: quit;

