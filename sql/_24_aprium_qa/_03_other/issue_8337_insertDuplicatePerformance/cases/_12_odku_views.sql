drop table if exists tt, t,t1,t2,a;
create table t(i bigint, j SMALLINT, k NUMERIC(5,0),l FLOAT,m date,n varchar(200) ) partition by hash(i) partitions 5 ;
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);
create unique index u_t_i_k on t(j, k,i);
create unique index u_t_l_k on t(j, k,i,l);
create unique index u_t_m_k on t(j, k,i,l,m);
create unique index u_t_n_k on t(j, k,i,l,m,n);
alter table t add constraint primary key(i);

insert into t select rownum, rownum, rownum,rownum,TO_DATE('081225', 'YYMMDD'),rownum || '' from _db_class limit 5;

create table a (i int, s varchar(255));
insert into a select rownum, rownum from _db_class limit 5;

create view v as select * from a;

select * from a order by 1;
select * from t order by 1;
select * from v order by 1;

insert into t(i,j) select i, s from v on duplicate key update i = v.s, k = k+1;

select * from t order by 1;

insert into t(i,j) select i, s from v on duplicate key update i = v.s + 10, k = k+1;

select * from t order by 1;

drop view v;
drop table if exists a,b ;
drop table  if exists t;

create table t(i int auto_increment(1,1) primary key, j int, k int);
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);

insert into t select null, rownum, rownum from _db_class limit 5;

create table a (i int  auto_increment(1,1), s varchar(255));
create table b (i int, s varchar(255));
insert into a select null, rownum from _db_class limit 5;
insert into b select rownum, rownum from _db_class limit 5;

select * from t order by 1;

create view v as select a.i, b.s from a left join b on a.i = b.i;

select * from v order by 1;

insert into t (j, k) select s,i from v on duplicate key update i = v.s, k = k+1;

select i, j, k from t order by i;

insert into t (i) select t.i from v as t, t as u where t.i = u.i on duplicate key update i = v.s, k = k+1;

select * from t order  by i;

drop view v;

drop table a;
drop table b;
drop table t;

create table t(i int, j int auto_increment, k int,primary key(i,j));

create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);

insert into t select rownum, rownum, rownum from _db_class limit 5;

create table a (i int, s varchar(255));
create table b (i int, s varchar(255));
insert into a select rownum, rownum from _db_class limit 5;
insert into b select rownum, rownum from _db_class limit 5;

create view v as select * from t where i < 3 with check option;

create view u as select a.i as i, a.i as j, b.s as s from a left join b on a.i = b.i;

insert into v select i, i, s from u on duplicate key update i = u.s, k = k+1;

insert into v select i, i, s from u where i < 3 on duplicate key update i = u.s, k = k+1;

select i, j, k from t order by i;

insert into v (i) select v.i from u as v, v as u where v.i = u.i on duplicate key update i = u.s, k = k+1;

select * from t order  by i;

drop view v;
drop view u;
drop table a;
drop table b;
drop table t;
