/*
Test Case: related to CUBRIDSUS-13823 ( non-unique index insert causes deadlock )  
Priority: 1
Reference case:
Author: Lily

Test Point:
C1: insert into foo values (1),(1),(1),(1),(1),(1),(1),(1),(1),(1);
C2: insert into foo values (1),(1),(1),(1),(1),(1),(1),(1),(1),(1);
C1: insert into foo values (1);
C2: insert into foo values (1);
*/

/* preparation */
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: commit;
 
C1: drop table if exists foo;
C1: create table foo (a int);
C1: create index idx1 on foo (a);
C1: insert into foo select rownum from db_class limit 10;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: insert into foo values (1),(1),(1),(1),(1),(1),(1),(1),(1),(1);
MC: wait until C1 ready;
C2: insert into foo values (1),(1),(1),(1),(1),(1),(1),(1),(1),(1);
MC: wait until C2 ready;
C1: insert into foo values (1);
MC: wait until C1 ready;
C2: insert into foo values (1);
MC: wait until C2 ready;

C1: select count(*) from foo;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: set transaction isolation level repeatable read;
C1: drop table if exists foo;
C1: create table foo (a int);
C1: create index idx1 on foo (a);
C1: insert into foo select rownum from db_class limit 10;
C1: commit;
MC: wait until C1 ready;

C2: set transaction isolation level repeatable read;
C2: commit;
MC: wait until C2 ready;

/* test case */
C1: insert into foo values (1),(1),(1),(1),(1),(1),(1),(1),(1),(1);
MC: wait until C1 ready;
C2: insert into foo values (1),(1),(1),(1),(1),(1),(1),(1),(1),(1);
MC: wait until C2 ready;
C1: insert into foo values (1);
MC: wait until C1 ready;
C2: insert into foo values (1);
MC: wait until C2 ready;

C1: select count(*) from foo;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C2: quit;
C1: quit;
