/*
Test Case: update & update
Priority: 1
Reference case:
Author: Mandy

Test Point:
A target record may be already locked and modified (updated or deleted) by another transaction. In this case:
1. current transaction will wait for the first updating transaction to commit or rollback.
2. if the record was updated and a new version was created, the second transaction will try to update the latest committed version after re-evaluating the search condition: if the search condition is still satisfied, the object may be updated, otherwise it is ignored.
In this case, the search condition is still satisfied, check the second update is executed.

NUM_CLIENTS = 3
C1: update on table t1; commit
C2: update on table t1; re-evaluate and update
C3: select on table t1, and C3 is used to check the update result
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
C1: create table t1(t_date date primary key, client varchar(10)) partition by range (t_date) (partition p1 values less than ('2000-01-01'), partition p2 values less than ('2014-01-01'));
C1: insert into t1 values('1990-12-31','abc');insert into t1 values('1984-01-08','def');insert into t1 values('1999-12-31','abc');insert into t1 values('2000-01-01','abc');insert into t1 values('2002-01-02','def');insert into t1 values('2012-07-02','def');
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* both updates cross partitions*/
C1: update t1 set t_date=t_date-3 where t_date>='2000-01-01';
MC: wait until C1 ready;
C2: update t1 set t_date=t_date+2 where t_date>'1990-09-01' and t_date<='1999-12-31';
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;

