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
C1: update on table t1: 1, 4, 10, 13. C1 block C2 and C3 on the same object
C2: update on table t1: 4, 10, 13, 16
C3: update on table t1: 4, 13
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
C1: create table t1(id int, col varchar(10)) partition by range (id) (partition p0 values less than (10), partition p1 values less than (20));
C1: insert into t1 values(1,'abc');insert into t1 values(4,'def');insert into t1 values(10,'abc');insert into t1 values(13,'abc');insert into t1 values(16,'def');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t1 set id=id+1 where id<16;
MC: wait until C1 ready;
C2: update t1 set id=id+1 where id>1;
MC: wait until C2 blocked;
C3: update t1 set id=id+1 where id>3 and id<15; 
MC: wait until C3 blocked;
C1: commit;
MC: wait until C2 ready;
MC: wait until C3 ready;
C2: select * from t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
C3: select * from t1 order by 1,2;
C3: commit;
MC: wait until C3 ready;
/* C2 C3 abort, so we cannot see their update results */
C4: select * from t1 order by 1,2;

C4: commit;
C1: quit;
C2: quit;
C3: quit;
C4: quit;

