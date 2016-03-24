/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
count list partition table

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int AUTO_INCREMENT,f1 int,primary key(id,f1)) partition by list(f1)(partition p1 values in(1,2,3),partition p2 values in(4,5,6));
C1: insert into t(f1) values(1),(2),(3),(4),(5),(6);
C1: insert into t(f1) values(1),(2),(3),(4),(5),(6);
C1: insert into t(f1) values(1),(2),(3),(4),(5),(6);
C1: insert into t(f1) values(1),(2),(3),(4),(5),(6);
C1: insert into t(f1) values(1),(2),(3),(4),(5),(6);
C1: insert into t(f1) values(1),(2),(3),(4),(5),(6);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t(f1) values(1),(2),(3),(4),(5),(6);
MC: wait until C1 ready;
/* expected 36 rows*/
C2: select count(*) from t; 
MC: wait until C2 ready;
C1: commit work;
C2: commit;
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

