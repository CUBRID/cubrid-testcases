/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
-    Insert: no row locks acquired if no unique indexes 
-    Update: X_LOCK acquired on current instance 
one user insert, another update the same trim() row

NUM_CLIENTS = 2
prepare(1,' a')
C1: insert into t values(1,'a ');
C2: update t set col=concat(col,' ') where trim(col)='a'; --expected 'a ' will not be update
C1: commit
C2: commit
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(trim(col));
C1: insert into t values(1,'a ');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,' a');
MC: wait until C1 ready;
C2: update t set col=concat(col,' ') where trim(col)='a';
MC: wait until C2 ready;
C1: commit work;
C2: commit;
/* expected (1,' a')(1,'a  ')*/
C2: select * from t order by 1,2 desc;
C2: commit;

C2: quit;
C1: quit;

