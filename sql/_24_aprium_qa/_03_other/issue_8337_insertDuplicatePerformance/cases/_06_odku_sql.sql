drop table if exists tt, t,t1,t2;
create table t(i bigint auto_increment(1,2), j SMALLINT auto_increment(1,2), k int,l FLOAT,m TIMESTAMP ,n char(200) );
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);
create unique index u_t_i_k on t(j, k,i);
create unique index u_t_l_k on t(j, k,i,l);
create unique index u_t_m_k on t(j, k,i,l,m);
create unique index u_t_n_k on t(j, k,i,l,m,n);
alter table t add constraint primary key(i);

insert into t select null, rownum, rownum,rownum,TO_TIMESTAMP('13:10:30 12/25/2008'),rownum || '' from _db_class limit 5;

create table tt(i int auto_increment(1,2), j int, k int,l int,m date,n char(250) );

insert into tt select null, rownum, rownum,rownum,TO_TIMESTAMP('13:10:30 12/25/2008'),rownum || '' from _db_class limit 5;

alter table tt add constraint primary key(i);

insert into tt (i,j, k,l,m,n) select j,i, k,l,m,n from t on duplicate key update i = t.i, k = k+1;

create table t1(i int auto_increment(2,2), j int, k int,l int,m TIMESTAMP ,n char(250) );

create table t2(i int auto_increment(2,2), j SMALLINT, k int,l FLOAT,m date,n char(200) );

insert into t2 (i,j, k,l,m,n) select * from t ;

alter table t2 add constraint primary key(i);

insert into t1 (i,j, k,l,m,n) select * from t2 ;

alter table t1 add constraint primary key(j);

select * from tt order by 1;

select * from t order by 1;

insert into tt (j,i, k,l,m,n) select t1.i,t2.j,t1.k,t2.l,t1.m,t2.n from t1,t2 where t1.i=t2.i on duplicate key update i = i-100, k = k+1;

select * from tt order by 1;

select * from t order by 1;

select * from t1 order by 1;

select * from t2 order by 1;

drop table tt, t,t1,t2;
