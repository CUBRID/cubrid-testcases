/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
insert into ... select ... from ...

NUM_CLIENTS = 2
C1: insert into t values(3,'abc');
C2: insert into t select id+2,col from t where id<=6; --lock conflict with C1
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(1,'abc');
C1: insert into t values(7,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(3,'abc');
MC: wait until C1 ready;
/* lock conflict with C1 */
C2: insert into t select id+2,col from t where id<=6;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;

/* expected id: 1,7,3 */
C1: select * from t order by 1;
C1: commit work;
C2: commit;
/* expected id: 1,7,3 */
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

