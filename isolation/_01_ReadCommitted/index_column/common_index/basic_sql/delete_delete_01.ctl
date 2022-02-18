/*
Test Case: delete & delete 
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
-    Delete: X_LOCK acquired on current instance 
A begin delete
                   B begin delete included in A
                   B commit
A end delete
A commit

NUM_CLIENTS = 2
C1: delete from t where col=1 and 0 = (select sleep(1));
C2: delete from t where id=1101; --expected blocked
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int, col int);
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),(@newincr)%100 from db_class a,db_class b,db_class c limit 1500;
C1: create index idx_col on t(col);
C1: create index idx_id on t(id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t where col=1 and  (select sleep(5)=0)<>0;
MC: sleep 1;
C2: delete from t where id=1101; 
C2: commit work;
MC: wait until C2 ready;
MC: wait until C1 ready;

/* expected C2 delete 0 row */
C1: commit;
MC: wait until C1 ready;

/* expected 0 row selected */
C2: select * from t where id=1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
