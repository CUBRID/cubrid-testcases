/*
Test Case: delete & delete
Priority: 1
Reference case:
Author: Xu Rong

Test Plan: 
Test DELETE locks (X_LOCK on instance) in a basic primary key schema environment

Test Scenario:
C1 begin delete
                   C2 begin delete included in A (overlapped primary key)
                   C2 commit
C1 end delete
C1 commit

Test Point:
1) C2 needs to wait C1 completed 
2) The instances of C1 should be deleted and the instances of C2 shouldn't be deleted
   (i.e.the version will be updated, the C2 search condition is not satisfied anymore)
   
NUM_CLIENTS = 3
C1: delete from table t;  
C2: delete from table t;  
C3: select on table t; C3 is used to check the updated result
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key, col int);
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),(@newincr)%100 from db_class a,db_class b limit 300;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t where col = 1;
MC: wait until C1 ready;
C2: delete from t where id = 201; 
/* expect: C2 is blocked since X_LOCK on C1 */
MC: wait until C2 blocked;
C1: commit work;
MC: wait until C2 ready;
/* expect: C2 delete 0 row */
C2: commit;
/* expect: 0 row selected */
C3: select * from t where id = 1;
C3: commit;

C1: quit;
C2: quit;
C3: quit;