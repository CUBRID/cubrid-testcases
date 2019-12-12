create table t(i int) partition by hash(i) partitions 10;

insert into t select rownum from db_class a, db_class b limit 100;

select count(i) from t;

truncate table t;

select count(i) from t;

select * from t order by i;

drop table t;

create table t(i int auto_increment) partition by hash(i) partitions 10;

insert into t values(null);

insert into t select null from t;
insert into t select null from t;
insert into t select null from t;
insert into t select null from t;
insert into t select null from t;
insert into t select null from t;
insert into t select null from t;

select max(i) from t;

truncate table t;

insert into t values(null);

select max(i) from t;

drop table t;

create table t (i int primary key, j int unique, k int);

create index i_t_j_k on t(j, k);

create table a (i int auto_increment);
insert into a values(null);
insert into a select null from a;
insert into a select null from a;
insert into a select null from a;
insert into a select null from a;
insert into a select null from a;
insert into a select null from a;
insert into a select null from a;
insert into a select null from a;

insert into t select i, i, i from a;

select max(i) from t;

truncate table t;

show indexes from t;

drop table a;
drop table t;