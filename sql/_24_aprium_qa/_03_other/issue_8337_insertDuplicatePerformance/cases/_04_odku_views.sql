set system parameters 'create_table_reuseoid=no';
drop table if exists a, b, c, t;

create table t(i int, j int, k int);
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);

insert into t select rownum, rownum, rownum from _db_class limit 5;

create table a (i int, s varchar(255));
insert into a select rownum, rownum from _db_class limit 5;

create view v as select * from a;

insert into t (j, k) select i, s from v on duplicate key update i = v.s, k = k+1;

select i, s, insert into t(j, k) values(5, 5) from v;
select i, j, k from t order by i;

drop view v;
drop table a;
drop table t;

create table t(i int, j int, k int);
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);

insert into t select rownum, rownum, rownum from _db_class limit 5;

create table a (i int, s varchar(255));
create table b (i int, s varchar(255));
insert into a select rownum, rownum from _db_class limit 5;
insert into b select rownum, rownum from _db_class limit 5;

create view v as select a.i, b.s from a left join b on a.i = b.i;

insert into t (j, k) select i, s from v on duplicate key update i = v.s, k = k+1;

select i, j, k from t order by i;

insert into t (i) select t.i from v as t, t as u where t.i = u.i on duplicate key update i = v.s, k = k+1;

select * from t order  by i;

drop view v;
drop view u;

drop table a;
drop table b;
drop table t;

create table t(i int, j int, k int);

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
set system parameters 'create_table_reuseoid=yes';
