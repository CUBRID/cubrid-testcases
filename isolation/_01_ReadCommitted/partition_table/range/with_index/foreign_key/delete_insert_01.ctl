/*
Test Case: insert & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/foreign_key_column/insert_delete_01.ctl
Author: Rong Xu

Test Point:
B reference A, when there is overlap, test the behavior
there is rollback

NUM_CLIENTS = 2
A delete from referenced table, delete 2
B insert into reference table, insert 2 --expected hang in here
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
C1: create table father(id int,col varchar(10), primary key(id)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: create table child(id int,col varchar(10),foreign key(id) references father(id));
C1: insert into father values(1,'a');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from father where col='a';
MC: wait until C1 ready;
C2: insert into child values(1,'b');
MC: wait until C2 blocked;
C1: rollback;
MC: wait until C2 ready;
C2: commit;

/* expected father (1,'a'); child (1,'b')*/
C2: select * from father order by 1;
C2: select * from child order by 1,2;
C2: commit;

C2: quit;
C1: quit;

