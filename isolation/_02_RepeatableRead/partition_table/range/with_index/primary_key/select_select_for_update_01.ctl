/*
Test Case: select for update & select for update
Priority: 1
Reference case: 
Isolation Level: Repeatable Read
Author: Ray

Test Point:
C1 C2 operates select for update stmt
The tuples are not overlapped 

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10)) partition by range(id)(partition p1 values less than (100),partition p2 values less than MAXVALUE);
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),'a' from db_class a,db_class b,db_class c limit 200;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: select * from t where id = 30 for update;
MC: wait until C1 ready;
C2: select * from t where id = 130 for update;
MC: wait until C2 ready;
C1: update t set col = 'abcd' where id = 30;
C1: commit;
C2: select * from t where id = 30;
C2: update t set col = 'abcde' where id = 130;
C2: commit;
MC: wait until C2 ready;

C2: select * from t where id = 30 or id = 130 order by 1;
C2: commit;

C2: quit;
C1: quit;

