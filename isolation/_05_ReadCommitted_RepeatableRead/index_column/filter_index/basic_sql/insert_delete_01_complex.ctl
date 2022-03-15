/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Delete: X_LOCK acquired on current instance 

NUM_CLIENTS = 3
C3: select * from t where id=1;
C1: delete from t where col=1 and sleep(1,col)=1;
C2: insert into t values(1,1);
C2: select * from t where id=1; --expected 1 row selected
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col int);
C1: insert into t select rownum,rownum from db_class limit 3;
C1: create index colx on t(col) where col=1;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C3: select t.* from t where col=1 and sleep(10)=0 using index colx(+) order by 1,2;
MC: sleep 1;
C1: delete from t where col=1 and sleep(3)=0 using index colx(+);
MC: sleep 1;
C2: insert into t values(4,1);
C2: select * from t where col=1 using index colx(+) order by 1,2;
C2: commit;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
/* expected 1 row selected */
C2: select * from t where col=1 using index colx(+) order by 1,2;
C2: commit;
MC: wait until C2 ready;
C3: commit;

C3: quit;
C2: quit;
C1: quit;
