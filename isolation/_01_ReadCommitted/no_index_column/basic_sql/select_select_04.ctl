/* 
Test Case: select & select
Priority: 1
Reference case:
Author: Mandy

Test Point:
C1, C2 select on overlapped multi rows. 

NUM_CLIENTS = 2
C1: select on table person
C2: select on table person
*/
 
MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists person;
C1: create table person (name varchar(100), age int);
C1: insert into person (name, age) values ('Alicia Florrick', 40), ('Diane Lockhart', 52),('Cary Agos', 40),('Peter Florrick', 42);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: select * from person order by 1,2;
MC: wait until C1 ready;

C2: select * from person order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C1: select * from person where name like '%Florrick' order by 1,2;
MC: wait until C1 ready;

C2: select * from person where name='Peter Florrick';
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C1: select * from person where age < 50 order by 1,2;
MC: wait until C1 ready;

C2: select * from person where age = 40 order by name;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C1: select * from person where age < 52 order by 1,2;
MC: wait until C1 ready;

C2: select * from person where age < 42 order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C1: select * from person where age < 50 order by 1,2;
MC: wait until C1 ready;

C2: select * from person where name = 'Alicia Florrick';
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: select * from person where age < 42 order by 1,2;
MC: wait until C1 ready;
C2: select * from person where name like '%Florrick' order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: select * from person where name='Alicia Florrick';
MC: wait until C1 ready;
C2: select * from person where name like '%Florrick' order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: select * from person where age=40 order by name;
MC: wait until C1 ready;
C2: select * from person where name like '%Florrick' order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;

