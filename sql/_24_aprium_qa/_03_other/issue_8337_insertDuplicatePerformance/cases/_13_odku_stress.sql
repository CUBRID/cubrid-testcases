drop table if exists a, b, c, t,tt;
create table t(i int, j int, k int primary key);
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);

insert into t select rownum, rownum, rownum from _db_class a,db_class b,db_class c limit 100;

create table a (i int, s varchar(255));
insert into a select rownum, rownum from _db_class a,db_class b,db_class c limit 100;

insert into t (j, k) select i, s from a on duplicate key update i = i-1, k = k-1;

insert into t (j, k) select i, s from a on duplicate key update  i = a.s-100, k = k-100;

insert into t (j, k) select i, s from a on duplicate key update  i = null, k =null;

drop table if exists a, b, c, t,tt;
create table tt(i bigint, j int, k int);
create unique index u_t_i on tt(i);
create unique index u_t_j_k on tt(j, k);

insert into tt select rownum, rownum, rownum from _db_class a,db_class b,db_class c limit 500;

create table a (i bigint, s varchar(65535));

insert into a select rownum, rownum from _db_class a,db_class b,db_class c limit 500;

insert into tt (j, k) select i, s from a on duplicate key update i = i-1, k = k+1;

insert into tt (j, k) select i, s from a on duplicate key update  i = a.s+10, k = k+1, j = i;

insert into tt (j, k) select i, s from a on duplicate key update  i = null, k =null;

drop table if exists a, b, c, t,tt;


drop table if exists t;
create table t (i char(5000));
create unique index i_t on t(i);
insert into t select rownum from db_class a,db_class b ,db_class c limit 100; 
select count(*) from t where i> 100;
insert into t select rownum from db_class a,db_class b ,db_class c limit 100  on duplicate key update i = i+100;
select count(*) from t where i> 100;


drop table if exists t;
create table t (i bigint);
create unique index i_t on t(i);
insert into t select rownum from db_class a,db_class b ,db_class c limit 100; 
select count(*) from t where i> 100;
insert into t select rownum from db_class a,db_class b ,db_class c limit 100  on duplicate key update i = i+100;
select count(*) from t where i> 100;

drop table t;
