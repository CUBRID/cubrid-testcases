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
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),(@newincr)+70 from (select sleep(1)) x, t where chr(col)>='A' limit 3;
C2: update t set col=col+1 where chr(col)>'A';
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

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
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),(@newincr)+70 from (select sleep(1)) x, t where chr(col)>='A' limit 3;
C2: update t set col=col+1 where chr(col)>'A';

/* overlap on 70,violate unique index */
MC: wait until C1 blocked;
MC: wait until C2 ready;
C2: rollback;
MC: wait until C2 ready;

C1: commit work;
MC: wait until C1 ready;

/* expected (1,71)(2,72)(3,73)(4,68)(5,69)(6,70) */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

