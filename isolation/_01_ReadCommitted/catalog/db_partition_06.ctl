/*
Test Case: insert,update,delete & select db_partition 
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 insert db_partition
- C2 update db_partition
- C3 delete db_partition
- C4 select from db_partition
*/

MC: setup NUM_CLIENTS = 4;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;
C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level read committed;
C2: commit;
C3: commit;
C4: commit;
/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: DROP TABLE IF EXISTS t2;
C1: DROP TABLE IF EXISTS t3;
C1: DROP TABLE IF EXISTS t4;
C1: DROP TABLE IF EXISTS t5;
C1: DROP TABLE IF EXISTS t6;
C1: create table t1(id int,col char(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: create table t2(id int,col char(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: commit;
MC: wait until C1 ready;

/* test case */
/* different table */
C1: create table t3(id int,col char(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: CREATE TABLE t4(name VARCHAR (40), event VARCHAR (30)) PARTITION BY LIST (event) (PARTITION event1 VALUES IN ('Swim', 'Ath'),PARTITION event2 VALUES IN ('Judo', 'Taekwondo', 'Box'));
MC: wait until C1 ready;
C2: alter table t1 reorganize partition p1 into(partition p1_1 values less than (5),partition p1_2 values less than (10));
C2: ALTER TABLE t2 PROMOTE PARTITION p1;
C2: CREATE TABLE t5(code CHAR (3), name VARCHAR (50) ) PARTITION BY HASH (code) PARTITIONS 4; 
MC: wait until C2 ready;
C3: ALTER TABLE t2 DROP PARTITION p1;
MC: wait until C2 ready;
C4: select * from db_partition order by 1,2,3;
MC: wait until C4 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C4: select * from db_partition order by 1,2,3;
C4: commit;
MC: wait until C3 ready;

/* rollback */
C2: rename t4 as t4_rename;
C2: alter table t4_rename add partition(PARTITION event3 VALUES IN ('dance', 'sing','jump')); 
MC: wait until C2 ready;
C3: alter table t3 add partition(partition p3 values less than (3000)); 
C3: ALTER TABLE t1 DROP PARTITION p1_1;
MC: wait until C3 ready;
C4: create table t6(id int,col char(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C4: alter table t1 add partition(partition p3 values less than (200),partition p4 values less than MAXVALUE);
MC: wait until C4 blocked;
C1: select * from db_partition order by 1,2,3;
C1: commit;
MC: wait until C1 ready;

C2: rollback;
MC: wait until C2 ready;
C3: rollback;
MC: wait until C3 ready;
C4: rollback;
MC: wait until C4 ready;
C1: select * from db_partition order by 1,2,3;
C1: commit;
MC: wait until C3 ready;

C3: quit;
C2: quit;
C1: quit;
C4: quit;
