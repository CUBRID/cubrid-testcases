/*
Test Case:  alter & create table 
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
ALTER TABLE t2 DROP PARTITION p1; -- throws core
NUM_CLIENTS = 2
*/

/* preparation */

/* test case */
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: commit;
 
C1: DROP TABLE IF EXISTS t1;
C1: DROP TABLE IF EXISTS t2;
C1: create table t1(id int,col char(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: create table t2(id int,col char(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: commit;
MC: wait until C1 ready;
 
C2: alter table t1 reorganize partition p1 into(partition p1_1 values less than (5),partition p1_2 values less than (10));
C2: ALTER TABLE t2 PROMOTE PARTITION p1;
MC: wait until C2 ready;
C1: ALTER TABLE t2 DROP PARTITION p1;
C2: commit;
C1: commit;

C2: quit;
C1: quit;
