/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Lily

Test Point:
insert into ... select ... from ...

NUM_CLIENTS = 2
C1: insert into t select * from t1; --insert 3 rows
C1: commit;
C1: insert into t select * from t1;
C2: insert into t select * from t1; --only can see committed rows, insert 3 rows
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int);
C1: drop table if exists t1;
C1: create table t1(id int);
C1: insert into t1 values(1);insert into t1 values(2);insert into t1 values(3);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t select * from t1;
C1: commit;
C1: insert into t select * from t1;
MC: wait until C1 ready;
/* expected insert 3 rows */
C2: insert into t select * from t;
MC: wait until C2 ready;
C2: select * from t order by id;
C2: commit;          
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: insert into t select * from t;
C2: select * from t order by id;

C2: commit;
C2: quit;
C1: quit;
