/*
Test Case: insert & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/no_index_column/basic_sql/insert_delete_10.ctl 
Author: Rong Xu

Test Point:
changes committed after the query started are never seen
  A begin insert
                   B begin delete which satisfy A
                   B commit
  A insert end
  A commit

NUM_CLIENTS = 2
prepare (5,6,7)
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),'b' from t where sleep(1)=0 limit 3;
C2: delete from t where id>0 and sleep(1)=0;
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(5,'a');
C1: insert into t values(6,'a');
C1: insert into t values(7,'a');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),'b' from t, (select sleep(3)) x limit 3; 
C2: delete from t where id>0 and sleep(1) = 0;
MC: wait until C1 ready;
MC: wait until C2 ready;
C1: commit;          
MC: wait until C1 ready;

C2: commit;          
/* result should be (1,b)(2,b)(3,b) */
C2: select * from t order by 1,2; 
C2: commit;

C2: quit;
C1: quit;
