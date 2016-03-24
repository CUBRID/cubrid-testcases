/*
Test Case: update & select
Priority: 1
Reference case:
Author: Mandy

Test Point:
Test the visibility of uncommited data
1. Uncommitted data are never seen by other queries
2. The only visible uncommitted data are the effects of current transaction's dates, that is to say
   the new version is only visible to the current transaction
At the same time, check update does not block select.

NUM_CLIENTS = 2
C1: update on table t1
C2: Select on table t1
*/


MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


/* preparation */
C1: drop table if exists t1;
C1: create table t1(t_date date, client varchar(10)) partition by range (YEAR(t_date)) (partition p1 values less than (2000), partition p2 values less than (2004), partition p3 values less than (2010));
C1: insert into t1 values('1996-09-01','abc'),('1996-12-31','def'),('1999-12-31','abc'),('2000-01-01','gh'),('2008-03-15','def');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t1 set t_date=null where YEAR(t_date) between 1990 and 1999;
C1: select * from t1 order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 order by 1,2;
MC: wait until C2 ready;
C1: commit;
C2: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;


C1: quit;
C2: quit;
