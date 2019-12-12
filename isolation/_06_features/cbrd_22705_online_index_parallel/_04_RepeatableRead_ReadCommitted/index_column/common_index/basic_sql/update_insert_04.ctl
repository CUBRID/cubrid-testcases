/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Update: X_LOCK acquired on current instance
A begin update
                   B begin insert
                   B commit
A end update
A commit

NUM_CLIENTS = 2
C1: update t set col=10000 where col=1 and 0 = (select sleep(1));
C2: insert into t values(1,1);
C2: select * from t where col=1; --expected 1 row selected
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col int);
C1: insert into t select rownum,rownum%100 from db_class a,db_class b,db_class c where rownum <= 500;
C1: create index idx_col on t(col) with online parallel 3;
C1: create index idx_id on t(id) with online parallel 3;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set col=10000 where col=1 and 0 = (select sleep(1));
MC: sleep 2;
C2: insert into t values(1,1);
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;

/* expected 1 row selected */
C2: select * from t where col=1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
