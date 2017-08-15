/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
one user insert, another update the same trim() row

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(trim(col));
C1: insert into t values(1,'a ');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,' a');
MC: wait until C1 ready;
C2: update t set col=col||'' where trim(col)='a';
C2: commit;
MC: wait until C2 ready;
C1: commit work;

/* expected (1,' a')(1,'a  ')*/
C2: select * from t order by 1,2;
C2: commit;

C2: quit;
C1: quit;

