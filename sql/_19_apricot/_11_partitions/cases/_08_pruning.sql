--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

create table a (i int auto_increment);

insert into a values(NULL);
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;

create table t(i int) partition by hash(i) partitions 4;

insert into t select * from a;

update t set i = 100 where i = 3;

select i from t where i = 100;

select i from t where i = 3;

drop table t;
drop table a;

create table t(i int) partition by list(i) (partition p0 values in (1, 2, NULL), partition p1 values in (3, 4, 5));

create table tr_action(i int);

insert into t values(1),(NULL), (3), (5);

select i from t where i is null;

drop table t;


create table t(i int) partition by list(i) (partition p0 values in (1, 2, NULL), partition p1 values in (3, 4, 5));

create trigger tr_bef_update before update on t execute insert into tr_action values (obj.i);

update t set i = 4 where i is NULL;

drop table tr_action;

drop table t;


create table t(i int);
create index i_t_i on t(i);
insert into t values(1),(2),(3),(4),(5);
alter table t partition by hash(i) partitions 3;
drop table t;

create table a (i int auto_increment);

insert into a values(NULL);
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;
insert into a select NULL from a;

create table t(i int, j int, k int) partition by hash(j) partitions 10;

insert into t select i, i, i from a;

create index i_t_i_j on t(i, j);

select i, j from t where i = 5 and j = 5;

select i, j from t where i < j;

select * from t where j = some cast ({1, 2, 3} as set of int) order by j;

select * from t where j != some cast ({1, 2, 3} as set of int) order by j;

drop table t;


create table u (i int, j varchar(255), k int) partition by hash(j) partitions 10;

insert into t select i, i, i from a;

select * from u where j = elt(2, 'a', cast (2 as varchar(255)), '3', '4');

drop table u;

create table t (d date) partition by hash(d) partitions 3;

select * from t where d = sysdate;

select * from t where d = cast('2010-01-01' as date);

drop table t;


create table t(i int unique) partition by hash (i) partitions 3;

select * from t where i = 5;

drop table t;


create table t (i int) partition by hash(i) partitions 3;
insert into t select i from a;
create index i_t_i on t(i);

update statistics on t;

select i from t where 10 <= i and i <= 15 order by i;

select i from t where 10 <= i and i < 15 order by i;

select i from t where 10 < i and i <= 15 order by i;

select i from t where 10 < i and i < 15 order by i;

select i from t where i >= 10 order by i;

select i from t where i > 10 order by i;

select i from t where i < 10 order by i;

select i from t where i <= 10 order by i;

select i from t where i = 10 order by i;

drop table t;

create table t(d date) partition by list(year(d)) (partition p0 values in (2000, 2001, 2002), partition p1 values in (2003, 2004, 2006));

insert into t values('2001-01-01');

drop table t;

create table t(i int) partition by range(i + 1) (partition p0 values less than (100), partition p1 values less than (200));

insert into t values(1);

drop table t;

create table t(i int) partition by list(substring('aabbccdd', 3, i)) (partition p0 values in ('aa', 'bb'), partition p1 values in('cc', 'dd'));

insert into t values(2);

drop table t;

create table t(i int, j int, k int) partition by hash(j) partitions 10;

insert into t select i, i, i from a;

create index i_t_i on t(i);

select i, j from t where i = 5 and j = 5;

drop table t;

drop table a;

create table t (i int) partition by list(i) (partition p0 values in (1, 2, 3), partition p1 values in (4, 5, 6));

insert into t values(7);

drop table t;

set system parameters 'dont_reuse_heap_file=no';

commit;
--+ holdcas off;

