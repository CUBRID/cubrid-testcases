/*
Test Case: insert & delete
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
B reference A, when there is overlap, test the behavior
delete without index

NUM_CLIENTS = 2
A insert into reference table, insert 2 
B delete from referenced table, delete 2 --expected hang in here
A rollback;
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
C1: create table father(id int primary key,col varchar(10));
C1: create table child(id int,col varchar(10),foreign key(id) references father(id));
C1: insert into father values(1,'a');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into child values(1,'mm');
MC: wait until C1 ready;
C2: delete from father where col='a';
MC: wait until C2 blocked;
C1: rollback;
MC: wait until C2 ready;
C2: commit;

/* expected father no value; child no value */
C2: select * from father order by 1;
C2: select * from child order by 1,2;
C2: commit;

C2: quit;
C1: quit;

