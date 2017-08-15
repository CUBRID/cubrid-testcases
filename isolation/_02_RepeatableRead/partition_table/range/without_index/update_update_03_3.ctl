/*
Test Case: update & update
Priority: 1
Reference case:
Author: Mandy

Test Point:
When two transaction update the same record, the second updater can proceed only if the first transaction rollbacks.
If the first transaction commits, the second transaction must be aborted.
In this case, where conditions are overlapped. C1's where condition totally includes C2's where condition.

NUM_CLIENTS = 3
C1: update on table t1; commit
C2: update on table t1; block, then abort
C3: select on table t1, and C3 is used to check the update result
*/


MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int, col varchar(10)) partition by range (id) (partition p0 values less than (10), partition p1 values less than (20));
C1: insert into t1 values(1,'abc');insert into t1 values(9,'def');insert into t1 values(10,'abc');insert into t1 values(11,'gh');insert into t1 values(15,'def');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t1 set id=id+1 where id>1;
C1: select * from t1 order by 1,2;
MC: wait until C1 ready;
C2: update t1 set id=id+1 where id>3;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: select * from t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* C2 abort, we cannot see C2's update result */
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;

