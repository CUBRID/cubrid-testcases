/*
Test Case:  savepoint & create table 
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
C1 create table and savepoint, C2 create another table

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS m;
C1: DROP TABLE IF EXISTS y;
C1: DROP TABLE IF EXISTS g;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: create table m (a int primary key); 
C1: commit;
C1: savepoint s1;
C1: rename table m as y;
C1: rollback to s1;
MC: wait until C1 ready;

C2: create table y (b int primary key);
MC: wait until C2 ready;

C1: create table g (a int primary key);
C1: commit;
C2: commit;

MC: wait until C2 ready;
C1: select * from m;
C1: select * from y;
C1: select * from g;
MC: wait until C1 ready;

C1: drop table m;
C1: drop table y;
C1: drop table g;
MC: wait until C1 ready;

C2: quit;
C1: quit;
