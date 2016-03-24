
create table t1(id1 int auto_increment, id2 int);
insert into t1 values (default,default), (default,default), (default,default);
select * from t1 order by 1;

delete from t1 where id1 = 2;
insert into t1 values (default,default), (default,default), (default,default);
select * from t1 order by 1; 

drop table t1;



create table t1(id1 int not null auto_increment, id2 int);
insert into t1 values (default,default), (default,default), (default,default);
select * from t1 order by 1;

delete from t1 where id1 = 2;
insert into t1 values (default,default), (default,default), (default,default);
select * from t1 order by 1; 

drop table t1;



create table t1(id1 int auto_increment, id2 int);
insert into t1 values (default,default), (default,default), (default,default);
select * from t1 order by 1;

create vclass vt1(id1 int, id2 int) as select * from t1;
select * from vt1 order by 1; 

delete from t1 where id1 = 2;
insert into t1 values (default,default), (default,default), (default,default);
select * from vt1 order by 1; 

drop vclass vt1;
drop table t1;




create table t1(id1 int not null auto_increment, id2 int);
insert into t1 values (default,default), (default,default), (default,default);
select * from t1 order by 1;

create vclass vt1(id1 int, id2 int) as select * from t1;
select * from vt1 order by 1; 

delete from t1 where id1 = 2;
insert into t1 values (default,default), (default,default), (default,default);
select * from vt1 order by 1; 

drop vclass vt1;
drop table t1;
