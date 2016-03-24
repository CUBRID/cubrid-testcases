drop table if exists t1;
create table t1(i int primary key);
insert into t1 values(1);
create table t2(i int,j int) partition by hash(i) partitions 4;
alter table t2 add constraint foreign key t2(i) references t1(i);
insert into t2 values(NULL,2),(1,2);
select * from t1 left join t2 on t1.i=t2.i order by 1,2,3;
select * from t1 , t2 where t1.i=t2.i order by 1,2,3;
select * from t1 right join t2 on t1.i=t2.i order by 1,2,3;

drop t2,t1;

create table t1(i int auto_increment,j int, primary key(i,j));
insert into t1 values(1,2),(NULL,3);
create table t2(i int,j int,k int) partition by hash(i) partitions 4;
alter table t2 add constraint foreign key t2(i,j) references t1(i,j);
insert into t2 values(1,2,1),(1,2,NULL);

select * from t1 left join t2 on t1.i=t2.i and t1.j=t2.j order by 1,2,3,4,5;
select * from t1 , t2 where t1.i=t2.i and t1.j=t2.j order by 1,2,3,4,5;
select * from t1 right join t2 on t1.i=t2.i and t1.j=t2.j order by 1,2,3,4,5;
select * from t1 right join t1 t2 on t1.i=t2.i and t1.j=t2.j order by 1,2,3,4;
select * from t1 right join t1 t2 on t1.i=t2.i order by 1,2,3,4;
select * from t1 left join t2 on t1.i=t2.i union select * from t1 right join t2 on t1.i=t2.i order by 1,2,3,4,5;
select * from t1 left join t2 on t1.i=t2.i union all select * from t1 right join t2 on t1.i=t2.i order by 1,2 desc,3,4,5 desc;
drop t2,t1;


create table t1(v varchar(10) primary key);
insert into t1 values('1');
create table t2(v varchar,j int) partition by hash(v) partitions 4;
alter table t2 add constraint foreign key t2(v) references t1(v);
insert into t2 values(NULL,2),('1',2);
select * from t1 left join t2 on t1.v=t2.v order by 1,2,3;
select * from t1 , t2 where t1.v=t2.v order by 1,2,3;
select * from t1 right join t2 on t1.v=t2.v order by 1,2,3;
drop t2,t1;

create table t1(v varchar(10),j int, primary key(v,j));
insert into t1 values('1',2),('',3);
create table t2(v varchar(10),j int,k int) partition by hash(v) partitions 4;
alter table t2 add constraint foreign key t2(v,j) references t1(v,j);
insert into t2 values('1',2,1),('1',2,NULL);

select * from t1 left join t2 on t1.v=t2.v and t1.j=t2.j order by 1,2,3,4,5;
select * from t1 , t2 where t1.v=t2.v and t1.j=t2.j order by 1,2,3,4,5;
select * from t1 right join t2 on t1.v=t2.v and t1.j=t2.j order by 1,2,3,4,5;
select * from t1 right join t1 t2 on t1.v=t2.v and t1.j=t2.j order by 1,2,3,4;
select * from t1 right join t1 t2 on t1.v=t2.v order by 1,2,3,4;
select * from t1 left join t2 on t1.v=t2.v union select * from t1 right join t2 on t1.v=t2.v order by 1,2,3,4,5;
select * from t1 left join t2 on t1.v=t2.v union all select * from t1 right join t2 on t1.v=t2.v order by 1,2 desc,3,4,5 desc;
drop t2,t1;
