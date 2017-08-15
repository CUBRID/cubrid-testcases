/*
Test Case: related to CUBRIDSUS-13890
Priority: 1
Reference case: http://bts4.nhncorp.com/nhnbts/browse/CUBRIDSUS-13890
Author: Lily

Test point:
same scenario are executed in following three isolation levels:
  -- read committed
  -- repeatable read
  --serializable
*/

/* preparation */
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: commit;
C1: drop table if exists foo;
C1: create table foo (a int, b int, c int);
C1: create index idx1 on foo (a, b);
C1: insert into foo select 1, rownum, rownum from db_class w, db_class x, db_class y, db_class z limit 10;
C1: commit;
MC: wait until C1 ready;

/* test case 1 -- read committed */
C2: select a, b, c from foo where a > 0 and c = 10; 
MC: wait until C2 ready;
C1: insert into foo values (1,2,10);
MC: wait until C1 ready;
C2: select a, b, c from foo where a > 0 and c = 10;
C2: commit;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;

C1: set transaction isolation level repeatable read;
C2: set transaction isolation level repeatable read;
C2: commit;
C1: drop table if exists foo;
C1: create table foo (a int, b int, c int);
C1: create index idx1 on foo (a, b);
C1: insert into foo select 1, rownum, rownum from db_class w, db_class x, db_class y, db_class z limit 10;
C1: commit;
MC: wait until C1 ready;

/* test case 2 -- repeatable read */
C2: select a, b, c from foo where a > 0 and c = 10;
MC: wait until C2 ready;
C1: insert into foo values (1,2,10);
MC: wait until C1 ready;
C2: select a, b, c from foo where a > 0 and c = 10;
C2: commit;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;

C1: set transaction isolation level serializable;
C2: set transaction isolation level serializable;
C2: commit;
C1: drop table if exists foo;
C1: create table foo (a int, b int, c int);
C1: create index idx1 on foo (a, b);
C1: insert into foo select 1, rownum, rownum from db_class w, db_class x, db_class y, db_class z limit 10;
C1: commit;
MC: wait until C1 ready;

/* test case 2 -- serializable */
C2: select a, b, c from foo where a > 0 and c = 10;
MC: wait until C2 ready;
C1: insert into foo values (1,2,10);
MC: wait until C1 ready;
C2: select a, b, c from foo where a > 0 and c = 10;
C2: commit;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;

C1: quit;
C2: quit;

