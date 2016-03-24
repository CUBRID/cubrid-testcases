create table t1(e enum('a', 'b       ', 'c', 'd'));
insert into t1 values(1), (2), (3), (4);

select * from t1 where e='a' order by 1;
select * from t1 where e='a    ' order by 1;
select * from t1 where e='  a' order by 1;
select * from t1 where e='  a   ' order by 1;
select * from t1 where e='b       ' order by 1;
select * from t1 where e='b' order by 1;

insert into t1 values ('a  '), ('a'), ('b'), ('b '), ('b   '), ('c      '), ('d');
select '''' + e + '''' from t1 order by 1;

insert into t1 values('   a');
select '''' + e + '''' from t1 order by 1;

create table t2(c char(10), v varchar(10));
insert into t2 values ('a', 'a'), ('b', 'b  '), ('c', 'c');

select '''' + t1.e + '''', '''' + t2.c + '''' from t1, t2 where t1.e=t2.c order by 1, 2;
select '''' + t1.e + '''', '''' + t2.v + '''' from t1, t2 where t1.e=t2.v order by 1, 2;
insert into t1 select c from t2;
select '''' + e + '''' from t1 order by 1;
insert into t1 select v from t2;
select '''' + e + '''' from t1 order by 1;

create table t3(e enum('a', 'a     '));

drop table t1;
drop table t2;
drop table t3;
