MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C1: drop table if exists child;
C1: drop table if exists father;
C1: create table father(id int primary key,col varchar(10));
C1: create table child(id int,col varchar(10),foreign key(id) references father(id));
C1: commit;

C1: insert into father values(1,'a');
MC: wait until C1 ready;
C2: insert into child values(1,'mm');
MC: wait until C2 blocked;
C1: rollback;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: select f.* from father f; -- no result
C1: select c.* from child c; -- no result

C1: quit;
C2: quit;
