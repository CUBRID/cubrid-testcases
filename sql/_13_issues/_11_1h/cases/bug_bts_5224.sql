
create table t (i int);
create index i_t_i on t(i);
insert into t values (1),(2);

create table t1 (s1 char(20),s2 char(5));
insert into t1 values ('dummy','i_t_i');

create table t2 (s1 varchar(20),s2 varchar(5));
insert into t2 values ('dummy','i_t_i');

select s2,index_cardinality('t',s2,0) from t1;
select s2,index_cardinality('t',s2,0) from t2;

drop table t;
drop table t1;
drop table t2;

