drop table if exists a, b, c, t;
create table t(i int, j int, k int);
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);

insert into t select rownum, rownum, rownum from _db_class limit 5;

create table a (i int, s varchar(255));
insert into a select rownum, rownum from _db_class limit 5;

insert into t (j, k) select i, s from a on duplicate key update i = a.s, k = k+1;

select i, j, k from t order by i;

drop table a;
drop table t;

create table t(i int, j int, k int);
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);

insert into t select rownum, rownum, rownum from _db_class limit 5;

create table a (i int, s varchar(255));
create table b (i int, s varchar(255));
create table c (i int, s varchar(255));
insert into a select rownum, rownum from _db_class limit 5;
insert into b select rownum, rownum from _db_class limit 5;
insert into c select rownum, rownum from _db_class limit 5;

insert into t (i, j, k) 
	select i, s from a
	union
	select i, s from b
	union
	select i, s from c
on duplicate key update i = a.s, j = b.s, k = k+1;

insert into t (i, j, k) select a, b, c from
	(
		select i, s, s from a  union select i, s, s from b union select i, s, s from c
	) x(a, b, c)
on duplicate key update i = x.a, j = x.b, k = x.c;

select i, j, k from t order by i,j ;

insert into t (j, k) select i+10, s from a on duplicate key update i = a.s+10, k = k+1, j = i;

select i, j, k from t order by i, j ;;

drop table a;
drop table b;
drop table c;

drop table t;

create table t(i int, j int, k int);
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);

insert into t select rownum, rownum, rownum from _db_class limit 5;

create table a (i int, s varchar(255));
insert into a select rownum, rownum from _db_class limit 5;

insert into t (j, k) select i, s from a on duplicate key update i = a.s, k = k+1, i = a+1;

select i, j, k from t order by i;

insert into t (j, k) select i, s from a on duplicate key update i = a.s, a.i = i+1, j = a.i+1;

select i, j, k from t order by i;

drop table a;
drop table t;
