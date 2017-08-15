/*
Test Case: select & select
Priority: 1
Reference case:
Author: Mandy

Test Point:
C1, C2 select on different single row

NUM_CLIENTS = 2
C1: select on table person
C2: select on table person
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* Preparation */
C1: drop table if exists person; 
C1: create table person (name varchar(100), age int);
C1: insert into person (name, age) values ('Alicia Florrick', 40), ('Diane Lockhart', 50);
C1: commit;
MC: wait until C1 ready;

/* select on different single row/
C1: select * from person where name='Alicia Florrick';
C2: select * from person where name='Diane Lockhart';
MC: wait until C1 ready;
MC: wait until C2 ready;
C1: commit;
C2: commit;

C1: quit;
C2: quit;

