/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Mandy

Test Point:
Test delete YEAR() in and select a sinle partition table
1. Reading queries can only have a look at data committed before the queries began
2. Uncommitted data are never seen
3. The only visible uncommitted data are the effects of current transaction's dates, that is to say
   the new version is only visible to the current transaction
At the same time check delete dose not block select


NUM_CLIENTS = 2
C1: delete, commit after C2's query start
C2: select twice - before C1 commit, after C1 commit
*/


MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


/* preparation */
C1: drop table if exists t1;
C1: create table t1(t_date date primary key, client varchar(10)) partition by hash (YEAR(t_date)) partitions 3;
C1: insert into t1 values('2000-01-01','abc'),('2002-02-28','def'),('2004-02-29','abc'),('2005-12-31','gh'),('2006-07-01','def');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t1 where YEAR(t_date) in (2000,2002,2006);
C1: select * from t1 partition(p0) where YEAR(t_date)<2010 order by 1,2;
C1: select * from t1 partition(p1) where YEAR(t_date)<2010 order by 1,2;
C1: select * from t1 partition(p2) where YEAR(t_date)<2010 order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 partition(p0) where YEAR(t_date)<2010 order by 1,2;
C2: select * from t1 partition(p1) where YEAR(t_date)<2010 order by 1,2;
C2: select * from t1 partition(p2) where YEAR(t_date)<2010 order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;

C1: select * from t1 partition(p0) where YEAR(t_date)<2010 order by 1,2;
C1: select * from t1 partition(p1) where YEAR(t_date)<2010 order by 1,2;
C1: select * from t1 partition(p2) where YEAR(t_date)<2010 order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 partition(p0) where YEAR(t_date)<2010 order by 1,2;
C2: select * from t1 partition(p1) where YEAR(t_date)<2010 order by 1,2;
C2: select * from t1 partition(p2) where YEAR(t_date)<2010 order by 1,2;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
