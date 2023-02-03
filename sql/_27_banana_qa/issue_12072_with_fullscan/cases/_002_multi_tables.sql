--update statistics on multiple tables.

create table t1(a int);

insert into t1 values(1);
insert into t1 values(1);
insert into t1 values(1);

create index idx on t1(a);
update statistics on t1;

insert into t1 values(2);
insert into t1 values(3);
insert into t1 values(4);

show index in t1;


create table t2(a int);

insert into t2 values(1);
insert into t2 values(1);
insert into t2 values(1);

create index idx on t2(a);
update statistics on t2;

insert into t2 values(2);
insert into t2 values(3);
insert into t2 values(4);

show index in t2; 


create table t3(a int);

insert into t3 values(1);
insert into t3 values(1);
insert into t3 values(1);

create index idx on t3(a);
update statistics on t3;

insert into t3 values(2);
insert into t3 values(3);
insert into t3 values(4);

show index in t3; 

select * from db_index where class_name in ('t1', 't2', 't3') order by class_name;

update statistics on all classes with fullscan;
update statistics on catalog classes with fullscan;

show index in t1;
show index in t2;
show index in t3;

select * from db_index where class_name in ('t1', 't2', 't3') order by class_name;

drop table t1;
drop table t2;
drop table t3;
