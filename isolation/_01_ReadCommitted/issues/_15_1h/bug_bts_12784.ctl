/*
Test Case: foreign key 
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
C1: update father set id=2 where id=1;
C2: insert into child values(2,'b'); --expected hang in here, waiting for C1 rollback or commit
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
 
C1: DROP TABLE IF EXISTS child;
C1: DROP TABLE IF EXISTS father;
C1: create table father(id int primary key,col varchar(10));
C1: create table child(id int,col varchar(10),foreign key(id) references father(id));
C1: insert into father values(1,'a');
C1: commit work;
MC: wait until C1 ready;
 
C1: update father set id=2 where id=1;
MC: wait until C1 ready;
C2: insert into child values(2,'b'); --expected hang in here, waiting for C1 rollback or commit
MC: wait until C2 blocked;
C1: rollback;
MC: wait until C2 ready;
C2: commit;

MC: wait until C2 ready;
C1: select * from father;
C1: select * from child;
C1: drop table child;
C1: drop table father;
C1: commit;


C2: quit;
C1: quit;
