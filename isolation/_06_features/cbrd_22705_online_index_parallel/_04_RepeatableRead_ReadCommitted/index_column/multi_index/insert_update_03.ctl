/*
Test Case: insert & update
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes. 
-    Update: X_LOCK acquired on current instance 
there are overlap between C1 and C2
two index, unique index and trim function index on the same column
one trim(col) versus more tuples

NUM_CLIENTS = 2
prepare(4,'a ')(5,' a')
C1: update t set col=concat(col,' ') where trim(col)='a';
C2: insert into t values(5,' a '); --expected blocked
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10) unique);
C1: create index idx on t(trim(col)) with online parallel 3;
C1: insert into t values(4,'a ');
C1: insert into t values(5,' a');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set col=concat(col,' ') where trim(col)='a';
MC: wait until C1 ready;

C2: insert into t values(5,' a ');
MC: wait until C2 blocked;

C1: commit;
MC: wait until C1 ready;

/* violate unique index */
MC: wait until C2 ready;
C2: commit;

/* expected C1 failed, values are (4,'a  ')(5,' a ') */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

