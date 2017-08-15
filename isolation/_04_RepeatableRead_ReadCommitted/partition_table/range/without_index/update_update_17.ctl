/*
Test Case: update & update
Priority: 1
Reference case:
Author: Mandy

Test Point:
C1 update, C2 update, the affected rows are not overlapped.
In this case, the first transaction's update result will affect the second transaction's search key value. In this case, the tran
sation is not blocked. Check the second update is executed correctly.

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
C1: create table t1(t_date date, client varchar(10)) partition by range (YEAR(t_date)) (partition p1 values less than (2000), partition p2 values less than (2004), partition p3 values less than (2010));
C1: insert into t1 values('1996-09-01','abc');insert into t1 values('1999-12-31','def');insert into t1 values('2002-09-01','abc');insert into t1 values('2005-02-14','gh');insert into t1 values('2008-03-15','def');
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* cross partitions*/
C1: update t1 set t_date=t_date+1 where YEAR(t_date)<2000;
MC: wait until C1 ready;
C2: update t1 set t_date=t_date-2 where YEAR(t_date)>=2000;
MC: wait until C2 ready;
C1: select * from t1 order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 order by 1,2;
MC: wait until C2 ready;
C1: commit;
C2: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;

