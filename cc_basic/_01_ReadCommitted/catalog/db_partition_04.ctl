/*
Test Case: delete & delete db_partition 
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 delete db_partition
- C2 delete db_partition
- C3 select from db_partition
*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;
C3: commit;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: DROP TABLE IF EXISTS t2;
C1: DROP TABLE IF EXISTS t3;
C1: create table t1(id int,col char(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: create table t2(id int,col char(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: create table t3(id int,col char(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: commit;
MC: wait until C1 ready;

/* test case */
/* different table */
C1: alter table t1 remove partitioning;
MC: wait until C1 ready;
C2: ALTER TABLE t2 DROP PARTITION p1;
MC: wait until C2 ready;
C3: select * from db_partition order by 1,2,3;
MC: wait until C3 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: select * from db_partition order by 1,2,3;
C3: commit;
MC: wait until C3 ready;

/* same table */
C2: ALTER TABLE t3 DROP PARTITION p1;
MC: wait until C2 ready;
C3: ALTER TABLE t3 DROP PARTITION p2;
MC: wait until C3 blocked;
C1: select * from db_partition order by 1,2,3;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C1: select * from db_partition order by 1,2,3;
C1: desc t3;
C1: insert into t3 values(2,'ab');
C1: insert into t3 values(10,'cd');
C1: select * from t3;
C1: commit;
MC: wait until C1 ready;

C3: quit;
C2: quit;
C1: quit;
