/*
Test Case: update & select
Priority: 1
Reference case:
Author: Mandy

Test Point:
Test update YEAR() in partition table
1. Reading queries can only have a look at data committed before the queries began
2. Uncommitted data are never seen
3. The only visible uncommitted data are the effects of current transaction's dates, that is to say
   the new version is only visible to the current transaction
At the same time check update dose not block select


NUM_CLIENTS = 2
C1: update, commit after C2's query start
C2: select twice - before C1 commit, after C1 commit
*/


MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


/* preparation */
C1: drop table if exists t1;
C1: create table t1(t_date date, client varchar(10)) partition by list (YEAR(t_date)) (partition p0 values in(2000,2004,2008), partition p1 values in(2001,2002,2003,2005,2006,2007));
C1: insert into t1 values('2000-01-01','abc'),('2002-02-28','abc'),('2004-02-29','def'),('2006-07-01','def');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t1 set t_date='2008-03-15' where YEAR(t_date)>2004;
C1: select * from t1 where YEAR(t_date)>1999 order by 1,2;
MC: wait until C1 ready;
C2: select t1.* from (select sleep(10)) x, t1 where YEAR(t_date)>1999 order by 1,2;
MC: sleep 2;
C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;

C1: select * from t1 where YEAR(t_date)>1999 order by 1,2;
C2: select * from t1 where YEAR(t_date)>1999 order by 1,2;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
