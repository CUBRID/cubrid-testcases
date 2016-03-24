drop table if exists t1,t2;

create table t1 (a int primary key) partition by hash(a) partitions 3; 
insert into t1 select rownum from db_class limit 44;

create table t2 (a int primary key) partition by hash(a) partitions 3; 
insert into t2 select rownum from db_class limit 48;

select * FROM t1 LEFT JOIN t2 ON t1.a=t2.a WHERE t1.a=25;
update statistics on all classes;
select /*+ recompile use_nl */ * FROM t1 LEFT JOIN t2 ON t1.a=t2.a ;

drop table t1,t2;

create table t1(a varchar(40),b  varchar(30)) partition by list(b) (partition b1 values in ('a','b') );
create table t2(a varchar(40),b  varchar(30)) partition by list(b) (partition b1 values in ('a','b') );

insert into t1 select 'a','b' from db_class limit 44;

insert into t1 select 'a1','b' from db_class limit 44;

insert into t2 select 'a','b' from db_class limit 44;

select * FROM t1 LEFT JOIN t2 ON t1.a=t2.a WHERE t1.a='a';

select * FROM t1 LEFT JOIN t2 ON t1.a=t2.a order by 1;


drop table t1;
drop table t2;

