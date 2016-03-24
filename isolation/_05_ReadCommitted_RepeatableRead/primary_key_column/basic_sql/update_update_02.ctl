/*
Test Case: update & update 
Priority: 1
Reference case:
Author: Mandy

Test Point: 
When two transaction update the same record, the second updater can proceed only if the first transaction rollbacks. 
If the first transaction commits, the second transaction must be aborted.

NUM_CLIENTS = 3 
C1: update on table t1; rollback  
C2: update on table t1
C3: select on table t1, and C3 is used to check the update result      
*/


MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int primary key, col varchar(10));
C1: insert into t1 values(1,'abc');insert into t1 values(2,'def');insert into t1 values(3,'abc');insert into t1 values(4,'ijk');insert into t1 values(5,'gh');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t1 set id=id-3 where id=3;
C1: select * from t1 order by 1,2;
MC: wait until C1 ready;
C2: update t1 set id=id+3 where id=3;
MC: wait until C2 blocked;
C1: rollback;
MC: wait until C2 ready;
C2: select * from t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* we can only see the update result of C2 */
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;

