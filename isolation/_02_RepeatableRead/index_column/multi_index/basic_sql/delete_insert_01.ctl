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
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10) unique);
C1: create index idx on t(id);
C1: insert into t values(3,'3a');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t select rownum,rownum ||'a' from (select sleep(5)) x, db_class limit 3;
MC: sleep 1;
C2: delete from t where col>'1';
MC: wait until C2 ready;
MC: wait until C1 blocked;

C2: commit;
MC: wait until C1 ready;
/* expected (3,3a) */
C1: select * from t order by 1,2;
C1: commit work;

C1: select * from t order by 1,2;
MC: wait until C1 ready;

C2: quit;
C1: quit;

