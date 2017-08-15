/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
Reading queries can only have a look at data committed before the transaction began
changes committed after the transaction started are never seen
there are many unvacuum version, test select sum(id) correctness
Combination:
a) some user committed before the query begin 
b) some begin before the select begin, but commit after the select begin 
c) some begin before the select begin, commit after the select end 
d) some begin after the select begin, commit before the select end 
e) some begin after the select begin, commit after the select end

NUM_CLIENTS = 6
*/
MC: setup NUM_CLIENTS = 6;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;
C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level repeatable read;
C5: set transaction lock timeout INFINITE;
C5: set transaction isolation level repeatable read;
C6: set transaction lock timeout INFINITE;
C6: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id BIGINT PRIMARY KEY,col VARCHAR(10));
C1: INSERT INTO tb1 SELECT rownum,rownum%10 FROM db_class a,db_class b,db_class c,db_class d LIMIT 100000;
C1: commit;
MC: wait until C1 ready;
C1: update tb1 set id=id+100000 where id%5=0;
MC: wait until C1 ready;

C2: update tb1 set id=id+100000 where id%5=1;
MC: wait until C2 ready;

C3: update tb1 set id=id+100000 where id%5=2;
MC: wait until C3 ready;

C4: update tb1 set id=id+100000 where id%5=3;
MC: wait until C4 ready;

C5: update tb1 set id=id+100000 where id%5=4;
MC: wait until C5 ready;

C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C3: commit;
MC: wait until C3 ready;

C4: commit;
MC: wait until C4 ready;

C5: commit;
MC: wait until C5 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id BETWEEN 100003 AND 100005;
MC: wait until C1 ready;
C5: DELETE FROM tb1 WHERE id BETWEEN 100010 AND 100020;
MC: wait until C5 ready;
C1: commit;
MC: sleep 1;
MC: wait until C1 ready;

C2: DELETE FROM tb1 WHERE id BETWEEN 100300 AND 100310;
MC: wait until C2 ready;

C6: SELECT col,SUM(id) FROM (select sleep(2)) x, tb1 WHERE id BETWEEN 100001 AND 190000 GROUP BY col ORDER BY col;

C3: DELETE FROM tb1 WHERE id BETWEEN 100100 AND 100150; 
MC: wait until C3 ready;
MC: wait until C6 ready;

C2: commit;
MC: wait until C2 ready;

C3: commit;
MC: wait until C3 ready;

C4: DELETE FROM tb1 WHERE id BETWEEN 100200 AND 100210 and (select sleep(1)=0);
MC: sleep 5;
C4: commit;
MC: wait until C4 ready;
C5: commit;
MC: wait until C5 ready;
C6: commit;
MC: wait until C6 ready;

C6: quit;
C5: quit;
C4: quit;
C3: quit;
C2: quit;
C1: quit;

