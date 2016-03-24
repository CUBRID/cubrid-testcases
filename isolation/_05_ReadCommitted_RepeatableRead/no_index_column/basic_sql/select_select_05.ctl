/*
Test Case: select & select
Priority: 1
Reference case:
Author: Lily

Test Point:
C1, C2, C3 select on non-overlapped/overlapped multi rows.

NUM_CLIENTS = 3
C1: Select on class t1
C2: Select on clase t1
C3: Select on clase t1
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists person;
C1: create table person (name varchar(100), age int, gender varchar(6));
C1: insert into person values ('Alicia Florrick',40,'female'); insert into person values('Diane Lockhart',52,'female');insert into person values('Cary Agos',40,'male');insert into person values('Peter Florrick', 42,'male');insert into person values ('Alicia Florrick',30,'female');
C1: commit work;

/* test case */
C1: select * from person where name='Diane Lockhart';
MC: wait until C1 ready;
C2: select * from person where name='Peter Florrick';
MC: wait until C2 ready;
C3: select * from person where name='Cary Agos';
MC: wait until C3 ready;
C1: commit;
C2: commit;
C3: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;

C1: select * from person order by 1,2;
MC: wait until C1 ready;
C2: select * from person order by 1,2;
MC: wait until C2 ready;
C3: select * from person order by 1,2;
MC: wait until C3 ready;
C1: commit;
C2: commit;
C3: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;

C1: select * from person where name like '%Florrick' order by 1,2,3;
MC: wait until C1 ready;
C2: select * from person where name='Peter Florrick';
MC: wait until C2 ready;
C3: select * from person where name='Alicia Florrick' order by 1,2;
MC: wait until C3 ready;
C1: commit;
C2: commit;
C3: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;

C1: select * from person where age < 60 order by 1,2,3;
MC: wait until C1 ready;
C2: select * from person where age < 50 order by 1,2,3;
MC: wait until C2 ready;
C3: select * from person where age < 42 order by 1,2,3;
MC: wait until C3 ready;
C1: commit;
C2: commit;
C3: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;

C1: select * from person where age < 60 order by 1,2,3;
MC: wait until C1 ready;
C2: select * from person where age < 50 order by 1,2,3;
MC: wait until C2 ready;
C3: select * from person where name like '%Florrick' order by 1,2,3;
MC: wait until C3 ready;
C1: commit;
C2: commit;
C3: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;

C1: select * from person where name = 'Alicia Florrick' order by 1,2,3;
MC: wait until C1 ready;
C2: select * from person where name like '%Florrick' order by 1,2,3;
MC: wait until C2 ready;
C3: select * from person where age<60 order by 1,2;
MC: wait until C3 ready;
C1: commit;
C2: commit;
C3: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;

C1: select * from person where age < 42 order by 1,2,3;
MC: wait until C1 ready;
C2: select * from person where name like '%Florrick' order by 1,2,3;
MC: wait until C2 ready;
C2: select * from person where gender='female' order by 1,2,3;
MC: wait until C3 ready;
C1: rollback;
C2: rollback;
C3: rollback;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
