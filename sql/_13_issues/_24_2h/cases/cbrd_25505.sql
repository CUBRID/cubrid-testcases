-- Error in result of insert ... select .. on duplicate key update query with view

-- view of duplicate key test case
drop table if exists t;
drop table if exists a;
drop table if exists b;

create table t(i int, j int, k int);
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);

insert into t values (1, 1, 1), (2, 2, 2), (3, 3, 3);

create table a(i int, s int);
create table b(i int, s int);

insert into a values (1, 11), (2, 12), (3, 13);
insert into b values (1, 1), (2, 2), (3, 3);

create view v as select a.i, b.s from a left join b on a.i = b.i;

insert into t (j, k) select i, s from v on duplicate key update i = v.s, k = k+1;

select * from t;

-- tables v alias duplicate key test case 
drop index u_t_i on t;
drop index u_t_j_k on t;
drop table if exists t;

create table t(i int, j int, k int);
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);

insert into t values (1, 1, 1), (2, 2, 2), (3, 3, 3);
insert into t (j, k) select v.i, b.s from a v left outer join b b on v.i=b.i on duplicate key update t.i=b.s, t.k=t.k+1;

select * from t;

-- inline view duplicate key test case
drop index u_t_i on t;
drop index u_t_j_k on t;
drop table if exists t;

create table t(i int, j int, k int);
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);

insert into t values (1, 1, 1), (2, 2, 2), (3, 3, 3);
insert into t (j, k) select v.i, v.s from (select v.i, b.s from a v left outer join b b on v.i=b.i) v (i, s) on duplicate key update t.i=v.s, t.k=t.k+1;

select * from t;

drop index u_t_i on t;
drop index u_t_j_k on t;
drop view v;
drop table t, a, b;
