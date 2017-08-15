/*
Test Case: insert & update
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes. 
-    Delete: X_LOCK acquired on current instance 
there are overlap between C1 and C2
two index, unique index and non unique index
insert using unique index, delete using non-unique index

NUM_CLIENTS = 2
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
C1: insert into t values(3,'3a');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),(@newincr) ||'a' from (select sleep(1)) x, t limit 3;
C2: delete from t where id>0;
C2: commit;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: commit work;
MC: wait until C1 ready;

/* expected (1,1a)(2,2a)(3,3a) */
C2: select * from t order by 1,2;
C2: commit;

C2: quit;
C1: quit;

