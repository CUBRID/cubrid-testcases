/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
insert into t select ... from ... ON DUPLICATE KEY UPDATE ...
A insert on duplicate ...
B insert rows including A inserted row -- expected waiting

NUM_CLIENTS = 2
C1: insert into t values(1,'a');
C2: insert into t values(1,'b'),(2,'c') on duplicate key update id=2; --expected blocked
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'a');
MC: wait until C1 ready;

C2: insert into t select rownum,'c' from db_class limit 3 on duplicate key update id=2;
MC: wait until C2 blocked;

C1: rollback;
MC: wait until C1 ready;
MC: wait until C2 ready;

/* expected (1,c)(2,c)(3,c) */
C1: select * from t order by 1,2;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C1: commit;
C2: quit;
C1: quit;

