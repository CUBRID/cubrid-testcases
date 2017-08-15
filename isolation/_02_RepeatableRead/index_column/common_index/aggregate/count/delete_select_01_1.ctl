/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/common_index/aggregate/delete_select_01.ctl
Author: Lily

Test Point:
Reading queries can only have a look at data committed before the transaction began
changes committed after the transaction started are never seen
there are many unvacuum version, test select count(id) correctness
Combination 
a) some user committed before the transaction begin 
b) some begin before the transaction begin, but commit after the transaction begin 
c) some begin before the transaction begin, commit after the transaction end 
d) some begin after the transaction begin, commit before the transaction end 
e) some begin after the transaction begin, commit after the transaction end
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
C1: INSERT INTO tb1 SELECT rownum,rownum%1 FROM db_class a,db_class b,db_class c,db_class d LIMIT 10;
C1: commit;
C1: UPDATE tb1 SET id=id-1,col=col||'aa';
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id BETWEEN 3 AND 5;
MC: wait until C1 ready;

C5: DELETE FROM tb1 WHERE id BETWEEN 10 AND 20 AND (select sleep(1)=0);
MC: wait until C5 ready;

C1: commit work;
MC: wait until C1 ready;

C2: DELETE FROM tb1 WHERE id BETWEEN 300 AND 310;
MC: wait until C2 ready;

C6: SELECT col,COUNT(id) FROM tb1 WHERE id BETWEEN 1 AND 9 GROUP BY col ORDER BY col;
MC: wait until C6 ready;

C3: DELETE FROM tb1 WHERE id BETWEEN 1 AND 2; 
MC: wait until C3 ready;

C2: commit work;
MC: wait until C2 ready;

C3: commit work;
MC: wait until C3 ready;

C4: DELETE FROM tb1 WHERE id BETWEEN 2 AND 3 and (select sleep(1)=0);
/*MC: sleep 6;*/
MC: wait until C4 ready;

C4: commit;
MC: wait until C4 ready;

C5: commit;
MC: wait until C5 ready;

C6: SELECT col,COUNT(id) FROM tb1 WHERE id BETWEEN 1 AND 9 GROUP BY col ORDER BY col;
C6: commit;
C6: quit;
MC: wait until C6 ready;

C5: quit;
C4: quit;
C3: quit;
C2: quit;
C1: quit;

