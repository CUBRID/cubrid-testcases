/*
Test Case: related to CUBRIDSUS-14493
Priority: 1
Reference case: http://bts4.nhncorp.com/nhnbts/browse/CUBRIDSUS-14493
Author: Lily

Test Point:
[MVCC] Correct rollback for physical delete from b-tree
*/

/* preparation */
MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;
C2: commit;
C3: commit;

/* test case */
C1: create table t1(id int, col1 varchar(10),col2 varchar(400), primary key(id,col1));
C1: create table t2(id int primary key,col1 varchar(10),col2 float,col3 varchar(400));
C1: create index idx1_t2 on t2(col1,col2);
C1: create table t3(id int,col1 varchar(10),col2 float,col3 varchar(400));
C1: create unique index idx1_t3 on t3(id,col1 desc);
C1: create unique index idx2_t3 on t3(col2 desc,col1);
C1: commit;

C1: insert into t1 select rownum,'abcdef',null from db_class a, db_class b,db_class c limit 5000;
C1: insert into t2 select rownum,'abcdef',rownum,null from db_class a, db_class b,db_class c limit 5000;
C1: insert into t3 select rownum,'abcdef',rownum,repeat('abc',50) from db_class a, db_class b,db_class c limit 5000;
C1: commit;
MC: wait until C1 ready;

/* delete from btree */
C1: delete from t1 where id between 1000 and 2500; 
C1: update t2 set id=id+5000,col2=id where id between 2000 and 2500;
C1: insert into t3 select rownum,'website',rownum,repeat('abc',100) from db_class a, db_class b,db_class c limit 1000;
MC: wait until C1 ready;
C2: update t1 set col1='website' where id between 500 and 900;
C2: delete from t2 where id between 500 and 1500;
C2: delete from t3 where id between 200 and 1200;
MC: wait until C2 ready;
C3: select count(*) from t1;
C3: select count(*) from t2;
C3: select count(*) from t3;
MC: wait until C3 ready;
C1: rollback;
MC: wait until C1 ready;
C2: rollback;
MC: wait until C2 ready;
C3: select count(*) from t1;
C3: select count(*) from t2;
C3: select count(*) from t3;
C3: select * from t1 where id in (1001,2498,2502) order by 1,2;
C3: select * from t2 where id in (2002,7002,503,998) order by 1,2;
C3: select * from t3 where id in (998,202,1198) order by 1,2;
C3: commit;
MC: wait until C3 ready;

/* update on btree */
C1: update t1 set id=id-1,col1='website',col2=repeat('abc',50) where id between 1000 and 2500 and mod(id,2)=0;
C1: delete from t2 where id between 2000 and 2500;
C1: insert into t3 select rownum,'space',rownum, repeat('abc',100) from db_class a, db_class b,db_class c limit 1000;
MC: wait until C1 ready;
C2: delete from t1 where id between 500 and 900;
C2: update t2 set id=id+5000,col2=id+5000 where id between 500 and 1500;
C2: update t3 set id=id-1,col1='website',col2=col2-1 where id between 200 and 1200 and mod(id,2)=1;
MC: wait until C2 ready;
C3: select count(*) from t1;
C3: select count(*) from t2;
C3: select count(*) from t3;
MC: wait until C3 ready;
C1: rollback;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: select count(*) from t1;
C3: select count(*) from t2;
C3: select count(*) from t3;
C3: select * from t1 where id in (500,998,1001,2498,2502) order by 1,2;
C3: select * from t2 where id in (2002,2498,5503,6498) order by 1,2;
C3: select * from t3 where id in (998,202,1198,1202) order by 1,2;
C3: commit;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
