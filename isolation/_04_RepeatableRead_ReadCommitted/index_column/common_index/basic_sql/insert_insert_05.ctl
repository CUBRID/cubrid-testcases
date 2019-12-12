/*
Test Case: insert & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_insert_03.ctl
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
No Lock for non unique index
insert a lot of the same value

NUM_CLIENTS = 4
C1: insert 10000 rows, values(1);
C2: insert 10000 rows, values(1);
C3: insert 10000 rows, values(2);
C4: insert 10000 rows, values(3);
*/

MC: setup NUM_CLIENTS = 4;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int ,col varchar(10));
C1: create index idx on t(id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t select 1,'abc' from db_class a,db_class b,db_class c,db_class d where rownum <= 10000;
MC: wait until C1 ready;
C2: insert into t select 1,'abc' from db_class a,db_class b,db_class c,db_class d where rownum <= 10000;
MC: wait until C2 ready;
C3: insert into t select 2,'abc' from db_class a,db_class b,db_class c,db_class d where rownum <= 10000;
MC: wait until C3 ready;
C4: insert into t select 3,'abc' from db_class a,db_class b,db_class c,db_class d where rownum <= 10000;
MC: wait until C4 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C4: commit;
MC: wait until C4 ready;

/* expected (1,20000)(2,10000)(3,10000) */
C2: select id, count(id) from t group by id order by id;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
C3: quit;
C4: quit;
