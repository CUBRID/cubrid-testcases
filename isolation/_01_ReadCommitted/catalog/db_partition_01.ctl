/*
Test Case: read & write db_partition 
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 read db_partition
- C2 write db_partition
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C1: commit;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: DROP TABLE IF EXISTS t2;
C1: commit;

/* test case */
C1: create table t1(id int,col char(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
MC: wait until C1 ready;

C2: select * from db_partition order by 1,2,3;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
MC: sleep 1;

C1: create table t2(id int,col char(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
MC: wait until C1 ready;

C2: select * from db_partition order by 1,2,3;
MC: wait until C2 ready;
C1: commit;
C2: commit;

C2: quit;
C1: quit;
