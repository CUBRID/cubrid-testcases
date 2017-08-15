/*
Test Case: insert & update
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes. 
-    Update: X_LOCK acquired on current instance 
there are overlap between C1 and C2
two index, unique index and non unique index, index has overlap on column

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(col);
C1: create unique index u_idx on t(id,col);
C1: insert into t values(3,'3');
C1: insert into t values(5,'d');
C1: insert into t values(1,'1');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t select rownum,rownum ||'a'  from t where id>0 and (select sleep(5)) = 0 and rownum <= 3;
MC: sleep 1;
C2: update t set col=col||'a' where id>0;
MC: wait until C2 ready;
MC: wait until C1 blocked;

C2: commit work;
MC: wait until C1 ready;
C1: select * from t order by 1,2;
C1: commit;
MC: wait until C1 ready;

C2: select * from t order by 1,2;
C2: commit;

C1: quit;
C2: quit;

