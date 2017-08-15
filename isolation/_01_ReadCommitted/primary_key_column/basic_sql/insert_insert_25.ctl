/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
insert into t select ... from ... ON DUPLICATE KEY UPDATE ...
A begin insert on duplicate ...
    B insert rows including A inserted row
    B commit
A commit

NUM_CLIENTS = 2
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),'c' from db_class where sleep(1)=0 limit 3 on duplicate key update id=20;
C2: insert into t values(1,'a');
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key AUTO_INCREMENT,col varchar(10));
C1: create table t1(id int);
C1: insert into t1 values(1);
C1: insert into t1 values(2);
C1: insert into t1 values(3);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),'c' from t1, (select sleep(3)) x on duplicate key update id=20;
MC: sleep 1;
C2: insert into t values(3,'a');
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;

/* expected (1,c)(20,a)(2,c) */
C1: select * from t order by 1,2;
C1: commit;          

C2: quit;
C1: quit;

