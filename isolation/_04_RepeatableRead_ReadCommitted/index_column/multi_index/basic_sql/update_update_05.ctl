/*
Test Case: update & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/update_update_01.ctl
Author: Mandy

Test Point:
C1 update, C2 update, the affected rows are not overlapped.
In this case, 2 indexes are created

NUM_CLIENTS = 3
C1: update on table t1  
C2: update on table t1  
C3: select on table t1; C3 is used to check the update result
*/


MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int, col varchar(10));
C1: insert into t1 values(1,'abc');insert into t1 values(2,'ad');insert into t1 values(3,'gh');insert into t1 values(4,'ijk');insert into t1 values(5,'lmn');
C1: create index idx1 on t1(id);
C1: create index idx2 on t1(col);
C1: commit work;
MC: wait until C1 ready;

/* C1 update, C2 update*/
C1: update t1 set id=id-1 where id>3;
C2: update t1 set id=id+1 where col like 'a%';
MC: wait until C1 ready;
MC: wait until C2 ready;
C1: commit;
C2: commit;
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;
