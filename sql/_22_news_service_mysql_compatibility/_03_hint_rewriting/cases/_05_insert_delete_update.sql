create table t1 (id int primary key not null, a char(20), b timestamp, c int);
insert into t1 select rownum, 'AZ-'||rownum, now(), rownum%100 from db_class a, db_class b, db_class c limit 10000;
create index i_t1_a_b_c on t1(a,b,c);
create index i_t1_a_b on t1(a,b);
create index i_t1_a on t1(a);

insert into t1  select id+10000, a,b,c from t1 use index(i_t1_a_b_c) where a>'A' limit 0, 10000;
insert into t1  select * from t1 use index(i_t1_a_b) where a>'A' limit 10000000, 10000000;

update t1 use index (i_t1_a_b_c, i_t1_a_b, i_t1_a) set b=now() where a>'A' and id>10000;

delete from t1 use index (i_t1_a_b_c, i_t1_a_b, i_t1_a) where a>'A';

create table t2 as select id+10000 as [id+10000], a,b,c from t1 use index(i_t1_a_b_c) where a>'A' limit 1,10;

create table t3 as select * from t1 use index(i_t1_a_b) where a>'A' limit 10000000, 10000000;

insert into t3 select * from t1 use index (i_t1_a_b_c) where a='AZ-1000' union select * from t1 use index (i_t1_a_b) where a='AZ-2000';

--test:should fail
delete from t3 use index (i_t3_a) where a='AZ-1000';

create view v1 as select id,a,c from t1 use index (i_t1_a) where a> 'A';
select /*+ recompile */ sum(id) from v1 use index (i_t1_a) where a||'00'<'AZ-10' ;
select /*+ recompile */ sum(id) from t1 use index (i_t1_a);
drop view v1;

create view [as v1] as select id,a,c from t1 use index (i_t1_a) where a> 'A';
select /*+ recompile */ sum(id) from [as v1] use index (i_t1_a) where a||'00'<'AZ-10' ;
drop view [as v1];

--should fail
create table t4 like t1 use index(i_t1_a_b, i_t1_a);

create table t5 like t1;

truncate table t5 use index i_t1_a;

drop table t1;
drop table t2;
drop table t3;
drop table t4;
drop table t5;

