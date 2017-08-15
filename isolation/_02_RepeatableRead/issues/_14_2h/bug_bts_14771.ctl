/*
Test Case:  select & update 
Priority: 1
Reference case:
Author: Tonny

Test Point:
C1 select , C2 update.
Check C1 and C2 will run ok.

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int, col varchar(10));
C1: insert into t1 values(1,'abc'),(2,'def'),(3,'abc'),(1,'gh'),(1,'abc'),(4,'def'),(5,'ijk');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: select * from t1 where id=1 order by 1,2;
MC: wait until C1 ready;

C2: update t1 set id=id+1;
MC: wait until C2 ready;

C2: quit;
C1: quit;
