/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/aggregate/delete_select_01.ctl
Author: Lily

Test Point:
there is expr and subquery in sum, there are unvacuumed data, and uncommitted delete at the same time

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE mod(id,5)=0;
C2: SELECT SUM(t1.id) FROM tb1 t1 LEFT OUTER JOIN (SELECT MIN(tb1.col) AS col FROM tb1 WHERE id>5 GROUP BY mod(id,10) ) AS t2 ON t1.col=t2.col  GROUP BY t2.col;
*/
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT,col VARCHAR(10));
C1: INSERT INTO tb1 SELECT rownum,mod(rownum,100) FROM db_class a,db_class b,db_class c where rownum<=1000;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE mod(id,5)=0;
MC: sleep 1;
C2: SELECT SUM(t1.id) FROM tb1 t1 LEFT OUTER JOIN (SELECT MIN(tb1.col) AS col FROM tb1 WHERE id>5 GROUP BY mod(id,10) ) AS t2 ON t1.col=t2.col  GROUP BY t2.col order by 1;
MC: sleep 1;
C1: commit work;
MC: wait until C1 ready;
C2: SELECT SUM(t1.id) FROM tb1 t1 LEFT OUTER JOIN (SELECT MIN(tb1.col) AS col FROM tb1 WHERE id>5 GROUP BY mod(id,10) ) AS t2 ON t1.col=t2.col  GROUP BY t2.col order by 1;
C2: commit;
C2: SELECT SUM(t1.id) FROM tb1 t1 LEFT OUTER JOIN (SELECT MIN(tb1.col) AS col FROM tb1 WHERE id>5 GROUP BY mod(id,10) ) AS t2 ON t1.col=t2.col  GROUP BY t2.col order by 1;

C2: commit;
C1: quit;
C2: quit;

