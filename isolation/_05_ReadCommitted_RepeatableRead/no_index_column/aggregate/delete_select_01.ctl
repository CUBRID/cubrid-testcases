/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
simple sum, there are unvacuumed data, and uncommitted delete at the same time
C1 delete begin
                      C2 select sum() begin
C1 commit
                      C2 select sum() begin

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE mod(id,5)=0;
C2: SELECT SUM(id) FROM tb1; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT,col VARCHAR(10));
C1: INSERT INTO tb1 SELECT rownum,mod(rownum,100) FROM db_class a,db_class b,db_class c,db_class d where rownum<=10000;
C1: commit;
C1: UPDATE tb1 SET id=id-1,col=col+id;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE mod(id,5)=0;
MC: wait until C1 ready;
/* expected 4999950000 */ 
C2: SELECT SUM(t1.id) FROM (select tb1.* from tb1 order by id) t1;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: SELECT SUM(id) FROM tb1;
C2: commit work;
MC: wait until C2 ready;
/* expected 4000000000 */
C2: SELECT SUM(id) FROM tb1;
C2: commit;
C2: quit;
C1: quit;

