/*
Test Case: related to CUBRIDSUS-15119 ( update multiple rows ,partitiond table and non-partitioned table have different result )  
Priority: 1
Reference case:
Author: Zhan Lanlan

Test Point:
C1: update t set i=5 where j=1;
C2: update t set i=16 where j=1;
C1: select * from t;
C2: select * from t; --C1 update affect the result of C1,expect it not affect  

*/

/* preparation */
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: commit;
 
C1: drop table if exists t;
C1: create table t(i int ,j int) partition by range(i)(partition p0 values less than (10),partition p1 values less than (20));
C1: insert into t values (9,1);
C1: insert into t values (15,1);
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update t set i=5 where j=1;
MC: Wait until C1 ready;
C2: update t set i=16 where j=1;
MC: Wait until C2 blocked;
C1: commit;
MC: Wait until C1 ready;
MC: Wait until C2 ready;
C1: select * from t order by 1,2; 
MC: Wait until C1 ready;
C2: select * from t order by 1,2;
MC: Wait until C2 ready;

C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
