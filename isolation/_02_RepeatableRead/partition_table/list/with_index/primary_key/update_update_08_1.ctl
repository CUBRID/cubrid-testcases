/*
Test Case: update & update
Priority: 1
Reference case:
Author: Mandy

Test Point:
C1 update, C2 update, the affected rows are not overlapped.

NUM_CLIENTS = 3
C1: update on table t1  
C2: update on table t1  
C3: select on table t1; C3 is used to check the update result
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
C1: create table t1(t_date date primary key, client varchar(10)) partition by list (YEAR(t_date)) (partition p0 values in (2000,2004,2008), partition p1 values in (2001,2002,2003,2005,2006,2007));
C1: insert into t1 values('2000-01-02','abc');insert into t1 values('2004-02-29','abc');insert into t1 values('2004-12-31','def');insert into t1 values('2005-12-31','gh');insert into t1 values('2006-07-01','def');insert into t1 values('2008-08-08','beijing');
C1: commit work;
MC: wait until C1 ready;

/* C1 update, C2 update*/
C1: update t1 set t_date=t_date-1 where YEAR(t_date)>2004;
MC: wait until C1 ready;
C2: update t1 set t_date=t_date+1 where YEAR(t_date)=2004;
MC: wait until C2 ready;
C1: select * from t1 order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 order by 1,2;
MC: wait until C2 ready;
C1: commit;
C2: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
/* we can see both update results of C1 and C2 */
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;
