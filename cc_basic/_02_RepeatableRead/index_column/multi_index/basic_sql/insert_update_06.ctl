/*
Test Case: insert & update
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes. 
-    Update: X_LOCK acquired on current instance 
there are overlap between C1 and C2
two index, unique index and non unique index

NUM_CLIENTS = 2
prepare(4,3a)(5,d)(6,e) --(4,3a) overlap
C1: insert into t select rownum,rownum ||'a' from (select sleep(2)) x, t limit 3; --expected blocked
C2: update t set col=col||'a' where id>0 and sleep(1,id) using index idx;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10) unique);
C1: create index idx on t(id);
C1: insert into t values(4,'d');
C1: insert into t values(5,'e');
C1: insert into t values(6,'3a');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t select rownum, rownum ||'a' from (select sleep(5)) x, t limit 3; 
MC: sleep 1;
C2: update t set col=col||'a' where id>0;
MC: wait until C2 ready;
MC: wait until C1 blocked;
C2: commit;
MC: wait until C1 ready;

/* expect (4,d)(5,e)(6,3a) */
C1: select * from t order by 1,2;
C1: commit work;
MC: wait until C1 ready;

/* expected (4,da)(5,ea)(6,3a) */
C2: select * from t order by 1,2;
C2: commit;

C1: quit;
C2: quit;

