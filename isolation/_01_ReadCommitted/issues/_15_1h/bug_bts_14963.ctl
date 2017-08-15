/*
Test Case: related to CUBRIDSUS-14963 ( The re-evaluation is inconsistent when operates ROWNUM )
Priority: 1
Reference case:
Author: Bobo
*/
MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/*test point 1*/
C1: drop table IF EXISTS t1;
C1: create table t1 (a int, b varchar); 
C1: insert into t1 values(1,'a'),(2,'b'),(3,'c'),(4,'d');
C1: commit;
MC: wait until C1 ready;

C1: delete from t1 where a IN (1,2,3) and ROWNUM <= 2;
MC: wait until C1 ready;
C2: delete from t1 where a IN (2,3,4) and ROWNUM <= 2;
MC: wait until C2 blocked;
C1: commit; 
MC: wait until C2 ready;
C2: select * from t1 order by 1,2;
C2: commit; 
MC: wait until C2 ready;

/*test point 2*/
C1: drop table IF EXISTS t1;
C1: create table t1 (a int unique, b varchar);
C1: insert into t1 values(1,'a'),(2,'b'),(3,'c'),(4,'d');
C1: commit;

C1: delete from t1 where a IN (1,2,3) and ROWNUM <= 2;
MC: wait until C1 ready;
C2: delete from t1 where a IN (2,3,4) and ROWNUM <= 2;
MC: wait until C2 blocked;
C1: commit; 
MC: wait until C2 ready;
C2: select * from t1 order by 1,2;
C2: commit; 
MC: wait until C2 ready;

C1: quit;
C2: quit;

