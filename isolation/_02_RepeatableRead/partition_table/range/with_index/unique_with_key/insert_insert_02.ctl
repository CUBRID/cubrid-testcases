/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
X_LOCK on first key OID for unique indexes
three clients insert, there are unique conflict, the first rollback

NUM_CLIENTS = 3
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: create index idx on t(col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'a');
MC: wait until C1 ready;
C2: insert into t values(1,'a');
MC: wait until C2 blocked;
C3: insert into t values(1,'b');
MC: wait until C3 blocked;
C1: commit work;
MC: wait until C2 ready;
C2: commit work;
MC: wait until C3 ready;

/* expect no value */
C2: select * from t order by 1;
MC: wait until C2 ready;
/* expect no value */
C3: select * from t order by 1;
MC: wait until C3 ready;

C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;

C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C3: quit;
C2: quit;
C1: quit;

