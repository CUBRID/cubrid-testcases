/*
Priority: 1
Reference case:
Isolation Level: Repeatable Read/Repeatable Read
Author: Bobo

Test Plan: 
Test the scenario that the returned index information is correct.

Test Point:
1) Data in system table is inconsistent
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read; --or read committed
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read; --or read committed
C2: commit;
/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10)) partition by range(id)(partition p1 values less than (100),partition p2 values less than (500));
C1: commit;
/* test case */
C1: select * from db_partition order by 1,2,3,4;
C1: commit;
MC: wait until C1 ready;
C2: drop table t;
MC: wait until C2 ready;
C1: SELECT * FROM db_class where owner_name='PUBLIC' order by 1,2,3,4;
C1: select * from db_partition order by 1,2,3,4;
C1: commit;
MC: wait until C1 ready;
C2: commit;
C1: quit;
C2: quit;

