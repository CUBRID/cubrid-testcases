/*
Test Case: update & insert
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes. 
-    Update: X_LOCK acquired on current instance 
there are overlap between C1 and C2
two index, unique index and non unique index

NUM_CLIENTS = 2
C1: update t set col=concat(col,'a') where id>0 and 0 = (select sleep(1));
C2: set @newincr=0;
C2: insert into t select (@newincr:=@newincr+1),(@newincr) ||'a' from t where id>0 limit 3; --expected blocked
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10) unique);
C1: create index idx on t(id);
C1: insert into t values(4,'a');
C1: insert into t values(5,'d');
C1: insert into t values(6,'3');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set col=concat(col,'a') where id>0 and 0 = (select sleep(1));
C2: set @newincr=0;
C2: insert into t select (@newincr:=@newincr+1),concat((@newincr),'a') from t where id>0 limit 3;
MC: wait until C1 blocked;
MC: wait until C2 ready;
C2: rollback;
MC: wait until C2 ready;
C1: commit work;

/* expected (4,aa)(5,da)(6,3a) */
C2: select * from t order by 1,2;
C2: commit;

C2: quit;
C1: quit;

