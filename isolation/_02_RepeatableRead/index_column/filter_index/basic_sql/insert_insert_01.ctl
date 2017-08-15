/*
Test Case: insert & insert
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
No Lock for non unique index
insert a lot of the same value

NUM_CLIENTS = 4
C1: insert 100000 rows, values(1);
C2: insert 100000 rows, values(1);
C3: insert 100000 rows, values(2);
C4: insert 100000 rows, values(3);
*/

MC: setup NUM_CLIENTS = 4;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id bigint ,col varchar(10));
C1: create index idx on t(id) where id%2=0;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t select rownum,'abc' from db_class a,db_class b,db_class c limit 1000;
C2: insert into t select rownum,'abc' from db_class a,db_class b,db_class c limit 1000;
C3: insert into t select rownum,'abc' from db_class a,db_class b,db_class c limit 1000;
C4: insert into t select rownum,'abc' from db_class a,db_class b,db_class c limit 1000;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;
MC: wait until C4 ready;
C1: commit;
C2: commit;
C3: commit;
C4: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;
MC: wait until C4 ready;

/* expected (1002000) */
C2: select sum(id) from t where id%2=0 using index idx(+);
C2: commit;

C1: quit;
C2: quit;
C3: quit;
C4: quit;
