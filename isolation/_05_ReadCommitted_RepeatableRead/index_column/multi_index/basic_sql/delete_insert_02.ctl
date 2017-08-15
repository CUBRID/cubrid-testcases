/*
Test Case: delete & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/delete_insert_21.ctl
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Delete: X_LOCK acquired on current instance 
A begin delete
                   B begin insert
                   B commit
A end delete
A commit
A using unique index, B using two index

NUM_CLIENTS = 2
C1: delete from t where col='ab' and sleep(2,col)=1;
C2: insert into t values(1,'ab'); --expected failed, violate 
C1: create index idx on t(id);
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int ,col int);
C1: create unique index idx on t(id);
C1: insert into t select rownum,rownum%100 from db_class a,db_class b, db_class c where rownum <= 3000;
C1: create index idx_col on t(col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t where col=1;
MC: wait until C1 ready;
C2: insert into t values(1,1);
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: select * from t where id=1;
C2: commit work;

/* expect no value */
C2: select * from t where id=1;
C2: commit;

C1: quit;
C2: quit;
