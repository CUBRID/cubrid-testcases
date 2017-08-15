/*
Test Case: related to CUBRIDSUS-13823 ( non-unique index insert causes deadlock )  
Priority: 1
Reference case:
Author: Lily

Test Point:
C1: insert into foo values (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10);
C2: insert into foo values (1,21),(1,22),(1,23),(1,24),(1,25),(1,26),(1,27),(1,28),(1,29),(1,30);
C1: insert into foo values (1,11);
C2: insert into foo values (1,31);
*/

/* preparation */
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: commit;
 
C1: drop table if exists foo;
C1: create table foo (a int, b int, primary key (a,b));
C1: create index idx1 on foo (a);
C1: insert into foo select rownum, -1 from db_class limit 10;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: insert into foo values (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10);
MC: wait until C1 ready;
C2: insert into foo values (1,21),(1,22),(1,23),(1,24),(1,25),(1,26),(1,27),(1,28),(1,29),(1,30);
MC: wait until C2 ready;
C1: insert into foo values (1,11);
MC: wait until C1 ready;
C2: insert into foo values (1,31);
MC: wait until C2 ready;

C1: select count(*) from foo;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: set transaction isolation level repeatable read;
C1: drop table if exists foo;
C1: create table foo (a int, b int, primary key (a,b));
C1: create index idx1 on foo (a);
C1: insert into foo select rownum, -1 from db_class limit 10;
C1: commit;
MC: wait until C1 ready;

C2: set transaction isolation level repeatable read;
C2: commit;
MC: wait until C2 ready;

/* test case */
C1: insert into foo values (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10);
MC: wait until C1 ready;
C2: insert into foo values (1,21),(1,22),(1,23),(1,24),(1,25),(1,26),(1,27),(1,28),(1,29),(1,30);
MC: wait until C2 ready;
C1: insert into foo values (1,11);
MC: wait until C1 ready;
C2: insert into foo values (1,31);
MC: wait until C2 ready;

C1: select count(*) from foo;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C2: quit;
C1: quit;
