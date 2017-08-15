/*
Test Case: insert & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_insert_25.ctl
Author: Rong Xu

Test Point:
insert into t select ... from ... ON DUPLICATE KEY UPDATE ...
A begin insert on duplicate ...
    B insert rows including A inserted row
    B commit
A commit

NUM_CLIENTS = 2
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),'c' from db_class where 0 = (select sleep(1)) limit 3 on duplicate key
 update id=20;
C2: insert into t values(1,'a');
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int  AUTO_INCREMENT,col varchar(10));
C1: create unique index idx on t(id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),'c' from db_class where 0 = (select sleep(1)) limit 3 on duplicate key update id=20;
C2: insert into t values(3,'a');
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;

/* expected (1,c)(20,a)(2,c) */
C1: select * from t order by 1,2;
MC: wait until C1 ready;

C2: commit;          
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;

C2: quit;
C1: quit;

