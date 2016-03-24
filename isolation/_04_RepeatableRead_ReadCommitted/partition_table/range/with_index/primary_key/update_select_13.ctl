/*
Test Case: update & select
Priority: 1
Reference case:
Author: Mandy

Test Point:
1. Reading queries can only have a look at data committed before the queries began
2. changes committed after the query started are never seen

NUM_CLIENTS = 2
C1: update, commit after C2's query start
C2: select twice - before C1 commit, after C1 commit
*/


MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


/* preparation */
C1: drop table if exists t1;
C1: create table t1(t_date date primary key, client varchar(10)) partition by range (YEAR(t_date)) (partition p1 values less than (2000), partition p2 values less than (2004), partition p3 values less than (2010));
C1: insert into t1 values('1996-09-01','abc');insert into t1 values('1999-12-31','abc');insert into t1 values('2000-01-01','gh');insert into t1 values('2004-01-01','abc');insert into t1 values('2006-07-12','abc');insert into t1 values('2008-03-15','def');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t1 set t_date=t_date+1 where YEAR(t_date)>=2006;
MC: wait until C1 ready;
C2: select * from t1 where YEAR(t_date)>1995 and (select sleep(10))=0 order by 1,2;
MC: sleep 2;
C1: commit;
MC: wait until C1 ready;

C2: select * from t1 where YEAR(t_date)>1995 order by 1,2;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
