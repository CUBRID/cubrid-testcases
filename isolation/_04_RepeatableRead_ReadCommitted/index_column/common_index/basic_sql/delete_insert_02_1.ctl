/*
Test Case: delete & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/delete_insert_02.ctl
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes
-    Delete: X_LOCK acquired on current instance
one user delete,insert, another insert,delete;expected do not cause deadlock

NUM_CLIENTS = 2
C1: delete(3)
C2: delete(2)
C2: insert(3)
C2: ready
C1: insert(2)
C1: ready
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(id);
C1: insert into t values(1,'abc');
C1: insert into t values(2,'abc');
C1: insert into t values(3,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t where id=3;
MC: wait until C1 ready;

C2: delete from t where id=2;
C2: insert into t values(3,'abc3');
MC: wait until C2 ready;

C1: insert into t values(2,'abc2');
MC: wait until C1 ready;


/* expected (1,abc)(2,abc)(2,abc2) */
C1: select * from t order by 1,2;
MC: wait until C1 ready;


/* expected (1,abc)(3,abc3)(3,abc) */
C2: select * from t order by 1,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;


/* expected (1,abc)(2,abc2)(3,abc3) */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;


C2: quit;
C1: quit;
