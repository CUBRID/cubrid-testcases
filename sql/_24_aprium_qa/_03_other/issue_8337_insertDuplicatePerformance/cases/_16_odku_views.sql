drop table if exists t,a,b;

create table t(i int, j int, k int) ;

create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);

insert into t select rownum, rownum, rownum from _db_class limit 5;

create table a (i int, s varchar(255));
create table b (i int, s varchar(255));
insert into a select rownum, rownum from _db_class limit 5;
insert into b select rownum, rownum from _db_class limit 5;

create view v as select * from t where i < 3 with check option;

create view u as select a.i as i, a.i as j, b.s as s from a left join b on a.i = b.i;

insert into v select i, i, s from u on duplicate key update i = u.s+100, k = k+100;

alter view v as select * from t where i > 3 ;

alter view v as select * from t ;

alter view v as select * from t where i > 3 ;

insert into v select i, i, s from u on duplicate key update i = u.s-100, k = k-100;

insert into v select i, i, s from u where i < 3 on duplicate key update i = u.s, k = k+1;

select i, j, k from t order by i;

select * from t order  by i;

drop view v;
drop view u;

drop table if exists t,a,b;

create table t(i int, j int, k int, primary key(i)) partition by hash(i) partitions 5;

create unique index u_t_i on t(i);
create unique index u_t_j_k on t(i,j, k);

insert into t select rownum, rownum, rownum from _db_class limit 5;

create table a (i int, s varchar(255), primary key(i))  partition by hash(i) partitions 5;;
create table b (i int, s varchar(255), primary key(i))  partition by hash(i) partitions 5;;
insert into a select rownum, rownum from _db_class limit 5;
insert into b select rownum, rownum from _db_class limit 5;

create view v as select * from t where i < 3 with check option;

create view u as select a.i as i, a.i as j, b.s as s from a left join b on a.i = b.i;

insert into v select i, i, s from u on duplicate key update i = u.s+100, k = k+100;

alter view v as select * from t where i > 3 ;

alter view v as select * from t ;

alter view v as select * from t where i > 3 ;

insert into v select i, i, s from u on duplicate key update i = u.s-100, k = k-100;

insert into v select i, i, s from u where i < 3 on duplicate key update i = u.s, k = k+1;

select i, j, k from t order by i;

select * from t order  by i;

drop view v;
drop view u;

drop table if exists t,a,b;

drop table if exists a;
drop table if exists t2;
drop table if exists t;

drop table if exists t,t2;
create table t(i MONETARY, j int, k int);
create unique index u_t_i on t(i);

insert into t values(1,1,1);


create table t2(i MONETARY, j int, k int);
create unique index u_t2_i on t2(i);

insert into t2 values(1,1,1);

create trigger bef_upd_t before update on t execute insert into t2( i, j, k) values(new.i, new.j, new.k);

 ALTER unique INDEX u_t_i on t REBUILD;

insert into t select i , j , k from t2 where i>0  on duplicate key update i = t2.i+t2.i*0.1;

drop table if exists a;
drop table if exists t2;
drop table if exists t;


drop table if exists t1;
CREATE TABLE t1(a1 BIT);

INSERT INTO t1 VALUES (B'1');

create unique index u_bit_t1_a on t1(a1);

INSERT INTO t1 VALUES (B'1');

select * from t1;

insert into t1 select B'1' from db_class  limit 3 on duplicate key update a1 =  B'1';



drop table if exists t1;
CREATE TABLE t1(a1 int,b int);

INSERT INTO t1 VALUES (1,1);

create unique index u_t1_a on t1(a1);

select * from t1 order by 1;

insert into t1 select 1 ,1 from db_class limit 3 on duplicate key update a1 = a1,b= b;


drop table if exists t1;
CREATE TABLE t1(a1 int,b varchar(6000));

INSERT INTO t1 select rownum,rownum from db_class a,db_class b,db_class c limit 700;

create unique index u_t1_a on t1(a1);

select * from t1 order by 1;

insert into t1 select 1,1 from db_class a,db_class b,db_class c limit 800 on duplicate key update a1 =  a1,b=b;


drop table if exists t1;
CREATE TABLE t1(a1 int,b varchar(6000));

INSERT INTO t1 select rownum,rownum from db_class a,db_class b,db_class c,db_class d limit 1000;

create unique index u_t1_a on t1(a1);

select b from t1 order by a1;

drop table t1;

drop table if exists t;
create table t (i1 char(20), i2 int, i3 varchar(20));
create index i_t_123 on t(i1, i2, i3);
create index i_t_321 on t(i2, i1, i3) where i1<i2;

insert into t select 0,rownum%10,rownum from db_class a,db_class b limit 1000;

insert into t select 0,rownum%10,rownum from db_class a,db_class b limit 1000;

select /*+ recompile */ * from t where i1=0 and i2 in ('0','1','2','3','4','5') using index i_t_123 keylimit 10 order by i3,i2 desc for orderby_num()<=10;

select /*+ NO_MULTI_RANGE_OPT */ * from t where i1=0 and i2 in ('0','1','2','3','4','5') using index i_t_123 keylimit 10 order by i3 for orderby_num()<=10;

select /*+ recompile */ * from t where i1=0 and i2 in ('0','1','2','3','4','5') using index i_t_123 keylimit 10 order by i3 desc ,i2  for orderby_num()<=10;

select /*+ NO_MULTI_RANGE_OPT */ * from t where i1=0 and i2 in ('0','1','2','3','4','5') using index i_t_123 keylimit 10 order by i3,i2 desc for orderby_num()<=10;

drop table t;
