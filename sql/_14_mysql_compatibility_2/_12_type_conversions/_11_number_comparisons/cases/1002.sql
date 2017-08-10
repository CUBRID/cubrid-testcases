--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t (i integer);
insert into t values(1);
insert into t values(2);
insert into t values(3);
insert into t values(4);
insert into t values(5);

create index i_t_i on t(i);

select * from t where i < 2 order by i;
select * from t where i < 2.1 order by i;
select * from t where i < cast(2.1 as float) order by i;
select * from t where i < cast(2.1 as double) order by i;
select * from t where i < '2.1' order by i;

select * from t where i > 2 order by i;
select * from t where i > 2.1 order by i;
select * from t where i > cast(2.1 as float) order by i;
select * from t where i > cast(2.1 as double) order by i;
select * from t where i > '2.1' order by i;

select * from t where i <= 2 order by i;
select * from t where i <= cast(2 as float) order by i;
select * from t where i <= cast(2 as double) order by i;
select * from t where i <= '2' order by i;

select * from t where i >= 2 order by i;
select * from t where i >= 2.1 order by i;
select * from t where i >= cast(2.1 as float) order by i;
select * from t where i >= cast(2.1 as double) order by i;
select * from t where i >= '2.1' order by i;

select * from t where i = 2 order by i;
select * from t where i = cast(2 as float) order by i;
select * from t where i = cast(2 as double) order by i;
select * from t where i = '2' order by i;

select * from t where i between 1 and 4 order by i;
select * from t where i in (1, 2, 3) order by i;
drop table t;

create table t (i numeric (10,4));
insert into t values(1);
insert into t values(2);
insert into t values(3);
insert into t values(4);
insert into t values(5);

create index i_t_i  on t(i);

select * from t where i < 2 order by i;
select * from t where i < 2.1 order by i;
select * from t where i < cast(2.1 as float) order by i;
select * from t where i < cast(2.1 as double) order by i;
select * from t where i < '2.1' order by i;

select * from t where i > 2 order by i;
select * from t where i > 2.1 order by i;
select * from t where i > cast(2.1 as float) order by i;
select * from t where i > cast(2.1 as double) order by i;
select * from t where i > '2.1' order by i;

select * from t where i <= 2 order by i;
select * from t where i <= cast(2 as float) order by i;
select * from t where i <= cast(2 as double) order by i;
select * from t where i <= '2' order by i;

select * from t where i >= 2 order by i;
select * from t where i >= 2.1 order by i;
select * from t where i >= cast(2.1 as float) order by i;
select * from t where i >= cast(2.1 as double) order by i;
select * from t where i >= '2.1' order by i;

select * from t where i = 2 order by i;
select * from t where i = cast(2 as float) order by i;
select * from t where i = cast(2 as double) order by i;
select * from t where i = '2' order by i;

select * from t where i between 1 and 4 order by i;
select * from t where i in (1, 2, 3) order by i;
drop table t;

create table t (i float);
insert into t values(1);
insert into t values(2);
insert into t values(3);
insert into t values(4);
insert into t values(5);

create index i_t_i on t(i);

select * from t where i < 2 order by i;
select * from t where i < 2.1 order by i;
select * from t where i < cast(2.1 as float) order by i;
select * from t where i < cast(2.1 as double) order by i;
select * from t where i < '2.1' order by i;

select * from t where i > 2 order by i;
select * from t where i > 2.1 order by i;
select * from t where i > cast(2.1 as float) order by i;
select * from t where i > cast(2.1 as double) order by i;
select * from t where i > '2.1' order by i;

select * from t where i <= 2 order by i;
select * from t where i <= cast(2 as float) order by i;
select * from t where i <= cast(2 as double) order by i;
select * from t where i <= '2' order by i;

select * from t where i >= 2 order by i;
select * from t where i >= 2.1 order by i;
select * from t where i >= cast(2.1 as float) order by i;
select * from t where i >= cast(2.1 as double) order by i;
select * from t where i >= '2.1' order by i;

select * from t where i = 2 order by i;
select * from t where i = cast(2 as float) order by i;
select * from t where i = cast(2 as double) order by i;
select * from t where i = '2' order by i;

select * from t where i between 1 and 4 order by i;
select * from t where i in (1, 2, 3) order by i;
drop table t;

create table t (i double);
insert into t values(1);
insert into t values(2);
insert into t values(3);
insert into t values(4);
insert into t values(5);

create index i_t_i  on t(i);

select * from t where i < 2 order by i;
select * from t where i < 2.1 order by i;
select * from t where i < cast(2.1 as float) order by i;
select * from t where i < cast(2.1 as double) order by i;
select * from t where i < '2.1' order by i;

select * from t where i > 2 order by i;
select * from t where i > 2.1 order by i;
select * from t where i > cast(2.1 as float) order by i;
select * from t where i > cast(2.1 as double) order by i;
select * from t where i > '2.1' order by i;

select * from t where i <= 2 order by i;
select * from t where i <= cast(2 as float) order by i;
select * from t where i <= cast(2 as double) order by i;
select * from t where i <= '2' order by i;

select * from t where i >= 2 order by i;
select * from t where i >= 2.1 order by i;
select * from t where i >= cast(2.1 as float) order by i;
select * from t where i >= cast(2.1 as double) order by i;
select * from t where i >= '2.1' order by i;

select * from t where i = 2 order by i;
select * from t where i = cast(2 as float) order by i;
select * from t where i = cast(2 as double) order by i;
select * from t where i = '2' order by i;

select * from t where i between 1 and 4 order by i;
select * from t where i in (1, 2, 3) order by i;
drop table t;
set  system parameters 'dont_reuse_heap_file=no';commit;
--+ holdcas off;
