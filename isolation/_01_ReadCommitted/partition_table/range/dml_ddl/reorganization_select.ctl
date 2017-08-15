/*
Test Case: reorganization partition & select
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
when there are lots of old version,one user reorganization partition, check another select

NUM_CLIENTS = 4
*/

MC: setup NUM_CLIENTS = 4;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col char(10)) partition by range(id)(partition p1 values less than (501),partition p2 values less than (2001));
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),'a' from db_class a,db_class b,db_class c, db_class d limit 1000;
C1: commit work;
C1: delete from t;
C1: commit work;
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),'a' from db_class a,db_class b,db_class c, db_class d limit 1000;
C1: commit work;

/* prepare old version */
C1: update t set id=id+500 where id%2=0;
C1: commit;

C1: update t set id=id+1;
C1: commit;

C1: update t set col='b';
C1: commit;

C1: update t set col='c';
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: alter table t reorganize partition p1 into(partition p1_1 values less than (200),partition p1_2 values less than (501));
C1: commit work;

/* id should from 3 to 802 */
C2: select count(*) from t partition(p1_1);
C2: select count(*) from t partition(p1_2);
C2: select count(*) from t partition(p2);
C2: select count(*) from t;
C2: commit;

C2: quit;
C1: quit;
C3: quit;
C4: quit;
