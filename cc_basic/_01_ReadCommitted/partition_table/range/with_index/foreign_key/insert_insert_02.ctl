/*
Test Case: insert & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/foreign_key_column/insert_insert_02.ctl
Author: Rong Xu

Test Point:
B reference A, when there is overlap, test the behavior

NUM_CLIENTS = 2
A insert into referenced table, insert 2
B insert into reference table, insert 2 --expected hang in here, waiting for A rollback or commit
A commit 
B commit
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists child;
C1: drop table if exists father;
C1: create table father(id int primary key,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: create table child(id int,col varchar(10),foreign key(id) references father(id));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into father values(1,'a');
MC: wait until C1 ready;
C2: insert into child values(1,'mm');
MC: wait until C2 blocked;

C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;

C2: commit;

/* expected father(1,a); child(1,mm) */
C2: select * from father order by 1;
C2: select * from child order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

