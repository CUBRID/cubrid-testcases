/*
Test Case: update & update
Priority: 1
Reference case:
Author: Mandy

Test Point:
When two transaction update the same record, the second updater can proceed only if the first transaction rollbacks.
If the first transaction commits, the second transaction must be aborted.

In this case, 3 transations update overlapped data. 

NUM_CLIENTS = 4 
C1: update on table t1  
C2: update on table t1 
C3: update on table t1 
C4: C4 select on table t1, this client is used to check the update result 
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
C1: drop table if exists t1;
C1: create table t1(id int, col varchar(10)) partition by list (id) (partition p0 values in (1,3,5,7), partition p1 values in (2,4,6,8));
C1: insert into t1 values(1,'abc');insert into t1 values(2,'def');insert into t1 values(3,'abc');insert into t1 values(4,'ijk');insert into t1 values(5,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t1 set id=1 where id<6;
MC: wait until C1 ready;
C2: update t1 set id=2 where id<5 and id>1;
MC: wait until C2 blocked;
C3: update t1 set id=3 where id>3; 
MC: wait until C3 blocked;
C1: commit;
MC: wait until C2 ready;
C2: select * from t1 order by 1,2;
MC: wait until C3 ready;
C3: select * from t1 order by 1,2;
C2: commit;
C3: commit;
MC: wait until C2 ready;
MC: wait until C3 ready;
/* C2 C3 abort, so we cannot see their update results */
C4: select * from t1 order by 1,2;

C4: commit;
C1: quit;
C2: quit;
C3: quit;
C4: quit;

