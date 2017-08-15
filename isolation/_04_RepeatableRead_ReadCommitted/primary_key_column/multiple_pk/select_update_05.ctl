/*
Test Case: update & select 
Priority: 1
Reference case:
Author: Mandy

Test Point:
Select:
Row: no row locks acquired
Table: IS_LOCK.
C1 select, C2 update, overlapped. Check select dose not block update

NUM_CLIENTS = 2 
C1: update and select on table t1
C2: select on table t1 before C1 commit
*/


MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int, col varchar(10), primary key(id,col));
C1: insert into t1 values(1,'abc');insert into t1 values(2,'def');insert into t1 values(3,'abc');insert into t1 values(4,'def');insert into t1 values(1,'ijk');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: select * from t1 where id=1 order by id;
MC: wait until C1 ready;
C2: update t1 set col='aa' where col='abc';
MC: wait until C1 ready;
C1: commit;
C2: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;


C1: quit;
C2: quit;
