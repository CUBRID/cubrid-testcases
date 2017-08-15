/*
Test Case: select & select
Priority: 1
Reference case:
Author: Lily

Test Point:
Reading queries can only have a look at data committed before the transaction began
changes committed after the transaction started are never seen
there are many unvacuum version, test select sum(id) correctness
NUM_CLIENTS = 5
*/
MC: setup NUM_CLIENTS = 4;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;
C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id BIGINT PRIMARY KEY,col VARCHAR(10));
C1: INSERT INTO tb1 SELECT rownum,rownum%10 FROM db_class a,db_class b,db_class c,db_class d where rownum<=10000;
C1: commit;
C1: UPDATE tb1 SET id=id-1,col=col||'aa';
MC: sleep 10;
C1: commit;


C1: DELETE FROM tb1 WHERE id BETWEEN 10 AND 20;
C4: DELETE FROM tb1 WHERE id BETWEEN 100 AND 150;
C1: commit;
C4: commit;
MC: wait until C1 ready;
MC: wait until C4 ready;

/* test case */
C1: SELECT DISTINCT col FROM tb1 WHERE id BETWEEN 1 AND 5000 GROUP BY col ORDER BY col;
MC: wait until C1 ready;
C2: SELECT col,AVG(id) FROM tb1 WHERE id BETWEEN 1 AND 9000 GROUP BY col ORDER BY col;
MC: wait until C2 ready;
C3: SELECT col,SUM(id) FROM tb1 WHERE id BETWEEN 1 AND 9000 GROUP BY col ORDER BY col;
C3: commit;
C2: commit;
C1: commit;
C4: quit;
C3: quit;
C2: quit;
C1: quit;

