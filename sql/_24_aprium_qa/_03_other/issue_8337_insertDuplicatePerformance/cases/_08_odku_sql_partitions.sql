drop table if exists t,t1,t2;

drop table if exists t__p__p0,t__p__p1;

CREATE TABLE t(i bigint, j SMALLINT, k NUMERIC(5,0),l FLOAT,m time,n char(200)) PARTITION BY LIST(i) (
    partition p0 values in (1, 2, 3),
    partition p1 values in (4, 5, 6),
    partition p2 values in (7, 8, 9),
    partition p3 values in (10, 11, 12)
);

create unique index u_t_i on t(i);

create unique index u_t_i_j_k on t(i,j, k);

alter table t add constraint primary key(i);

--ALTER TABLE t PROMOTE PARTITION p1, p0;

insert into t select rownum, rownum, rownum,rownum,TO_TIME ('13:10:30', 'HH24:MI:SS'),rownum || '' from _db_class limit 5;

create table t1(i int, j int, k NUMERIC(5,0),l int,m time,n char(250) )  partition by hash(j) partitions 5 ;

create table t2(i bigint, j SMALLINT, k NUMERIC(5,0),l FLOAT,m time,n char(200) )  partition by hash(i) partitions 5 ;

insert into t2 (i,j, k,l,m,n) select * from t ;

alter table t2 add constraint primary key(i);

insert into t1 (i,j, k,l,m,n) select * from t2 ;

alter table t1 add constraint primary key(j);

insert into t (j,i, k,l,m,n) select t1.i,t2.j,t1.k,t2.l,t1.m,t2.n from t1,t2 where t1.i=t2.i on duplicate key update i = i-100;

insert into t (j,i, k,l,m,n) select t1.i,t2.j,t1.k,t2.l,t1.m,t2.n from t1,t2 where t1.i=t2.i on duplicate key update i = i-1, k = k+1;

select * from t1 order by 1;

select * from t1 order by 1,2;

drop table t1,t2,t;

--drop table if exists t__p__p0,t__p__p1;
