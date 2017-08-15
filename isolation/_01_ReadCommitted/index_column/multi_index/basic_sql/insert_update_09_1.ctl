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
prepare(3,3)(5,d)(6,e) --(3,3a)(3,3a) overlap, expected violate unique
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),(@newincr) ||'a' from (select sleep(1)) x, t limit 3;
C2: update t set col=concat(col,'a') where id>0 and 0 = (select sleep(1)) using index idx;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create unique index idx on t(col);
C1: create unique index u_idx on t(id,col);
C1: insert into t values(4,'3');
C1: insert into t values(5,'d');
C1: insert into t values(6,'e');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),(@newincr) ||'a' from (select sleep(1)) x, t limit 3;
MC: wait until C1 ready;

/* although force to use idx, it should lock u_idx */
C2: update t set col=concat(col,'a') where id>0 and 0 = (select sleep(1)) using index idx;
MC: wait until C2 blocked;

C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;

C2: commit work;
MC: wait until C2 ready;

/* expected (4,3)(5,d)(6,e)(1,1a)(2,2a)(3,3a) */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

