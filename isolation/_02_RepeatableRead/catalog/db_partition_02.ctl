/*
Test Case: insert & insert db_partition 
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 insert db_partition
- C2 insert db_partition
- C3 select from db_partition
*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;
C3: commit;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: DROP TABLE IF EXISTS t2;
C1: DROP TABLE IF EXISTS t3;
C2: create table t2(id int,col char(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: commit;

/* test case */
/* different table */
C1: create table t1(id int,col char(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
MC: wait until C1 ready;
C2: alter table t2 add partition(partition p3 values less than (3000));  
MC: wait until C2 ready;
C3: select * from db_partition order by 1,2;
MC: wait until C3 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: select * from db_partition order by 1,2;
C3: commit;
C3: select * from db_partition order by 1,2;
C3: commit;
MC: wait until C3 ready;

/* same table */
C1: create table t3(id int,col char(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
MC: wait until C1 ready;
C2: create table t3(id int,col char(10)) partition by hash(id) partitions 4;
MC: wait until C2 blocked;
C3: select * from db_partition order by 1,2;
MC: wait until C3 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: select * from db_partition order by 1,2;
C3: commit;
C3: select * from db_partition order by 1,2;
C3: commit;
MC: wait until C3 ready;
C3: quit;
C2: quit;
C1: quit;
