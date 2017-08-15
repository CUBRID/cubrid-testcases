/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
  A begin delete
                   B begin insert
                   B commit
  A end delete
  A commit
do not use index

NUM_CLIENTS = 2
prepare (1,2,7)
C1: delete from t where col='abc' and sleep(1)=0;
C2: insert into t values(4,'abc'); --expected ok, and will not be deleted
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(1,'abc');
C1: insert into t values(7,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t where col='abc' and sleep(1)=0;
C2: insert into t values(4,'abc');
MC: wait until C2 ready;
MC: wait until C1 ready;
C2: commit;
C1: commit;
/* expected result is (4,abc) */
C1: select * from t order by 1,2;
C1: commit;

C2: quit;
C1: quit;
