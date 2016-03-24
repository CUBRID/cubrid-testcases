drop table if exists tt, t,t1,t2;
create table t(i bigint, j SMALLINT, k int,l FLOAT,m date,n char(200) );
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);
create unique index u_t_i_k on t(j, k,i);
create unique index u_t_l_k on t(j, k,i,l);
create unique index u_t_m_k on t(j, k,i,l,m);
create unique index u_t_n_k on t(j, k,i,l,m,n);
alter table t add constraint primary key(i);

create table tt under t;

insert into tt select rownum, rownum, rownum, rownum, CURRENT_DATE, rownum from _db_class limit 5;

create table t1(i bigint, j SMALLINT, k int,l FLOAT,m date,n char(200) );

insert into t1 select rownum, rownum, rownum, rownum, CURRENT_DATE+2, rownum from _db_class limit 5;

insert into t  select * from t1 on duplicate key update t.m=t1.m-1;

insert into tt  select * from t1 on duplicate key update tt.m=t1.m-1;

drop table  if exists tt, t,t1,t2,t3;
