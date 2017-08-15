/*
Test Case: CUBRIDSUS-14258
Priority: 1
Reference case: 
Author: Lily

Test Point:
partition table.
C1 insert a lot of rows, C2 insert a lot of rows.
then C1 commit and drop tables, C2 show tables.
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed; 

/* preparation */
C2: show tables;
MC: wait until C2 ready;

C1: DROP TABLE IF EXISTS t;
C1: DROP TABLE IF EXISTS db_class1;
C1: create table t(id int,col varchar(10),col1 varchar(10)) partition by range(id)(partition p1 values less than (500),partition p2 values less than (1002));
C1: create table db_class1(id int);
C1: insert into db_class1 values(1);
C1: insert into db_class1 select * from db_class1;
C1: insert into db_class1 select * from db_class1;
C1: insert into db_class1 select * from db_class1;
C1: insert into db_class1 select * from db_class1;
C1: insert into db_class1 select * from db_class1;
C1: insert into db_class1 select * from db_class1 limit 10;
C1: insert into db_class1 values(1);
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1)+1,'a','b' from db_class1 a,db_class1 b,db_class1 c,db_class1 d limit 400;
C1: create unique index idx on t(id,col);
C1: insert into t values(1,'a','c');
MC: wait until C1 ready;

/* C2: hang in here, C1 does not commit, why C2 hang? */
C2: set @newincr=0;
C2: insert into t select (@newincr:=@newincr+1),'a','b' from db_class1 a,db_class1 b,db_class1 c,db_class1 d limit 401 on duplicate key update t.id=t.id+500;
/*MC: wait until C2 ready;*/
MC: wait until C2 blocked;

C1: show tables;
C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;

/*
MC: sleep 100;
MC: sleep 50;*/

C1: show tables;
/*MC: sleep 100;*/

MC: wait until C1 ready;
/*
MC: sleep 100;
MC: sleep 20;*/

C2: show tables;
MC: wait until C2 ready;

C1: drop table t; --hang there
MC: wait until C1 blocked;

C2: commit;
/*
MC: sleep 5;(
MC: wait until C2 ready;
MC: wait until C1 ready;*/

C2: show tables;
MC: wait until C2 ready;
MC: wait until C1 ready;

C1: commit;
MC: wait until C1 ready;

C2: show tables;
MC: wait until C2 ready;

C1: quit;
C2: quit;
