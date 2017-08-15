/*
Test Case: insert & update
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes. 
-    Update: X_LOCK acquired on current instance 
there are overlap between C1 and C2
two index, unique index and chr function index on the same column

NUM_CLIENTS = 2
prepare(4,3a)(5,d)(6,e) --(4,3a) overlap
C1: insert into t select rownum,rownum+70 from (select sleep(1)) x, t where id>0 limit 3; --expected blocked
C2: update t set col=col+1 where chr(col)>'A' and 0=(select sleep (1)) using index idx;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10) unique);
C1: create index idx on t(chr(col));
C1: insert into t values(4,'68');
C1: insert into t values(5,'69');
C1: insert into t values(6,'70');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t select rownum, rownum+70 from (select sleep(5)) x, t where id>0 limit 3;
MC: sleep 1;
C2: update t set col=col+1 where chr(col)>'A' using index idx;

/* overlap on 70,violate unique index */
MC: wait until C1 blocked;
MC: wait until C2 ready;

/* expected C1 failed, values are (4,68)(5,69)(6,70) */
C2: commit;
MC: wait until C2 ready;
MC: wait until C1 ready;

C1: select * from t order by 1,2;
C1: commit work;
MC: wait until C1 ready;

/* expected C1 failed, values are (4,69)(5,70)(6,71) */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;

