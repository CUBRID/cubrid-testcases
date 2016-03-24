drop table if exists t,t1,t2;

CREATE TABLE t(i bigint, j SMALLINT, k NUMERIC(5,0),l FLOAT,m date,n char(200)) PARTITION BY RANGE(i) (
    partition p0 VALUES LESS THAN  (3),
    partition p1 VALUES LESS THAN  (7),
    partition p2 VALUES LESS THAN  (100),
    partition p3 VALUES LESS THAN  (1000)
);

create unique index u_t_i on t(i);

create unique index u_t_j_k on t(i, j, k);

alter table t add constraint primary key(i);

insert into t select rownum, rownum, rownum,rownum,TO_DATE('081225', 'YYMMDD'),rownum || '' from _db_class limit 5;

create table t1(i int, j int, k int,l int,m date,n char(250) )  partition by hash(j) partitions 5 ;

create table t2(i bigint, j SMALLINT, k NUMERIC(5,0),l FLOAT,m date,n char(200) )  partition by hash(i) partitions 5 ;

insert into t2 (i,j, k,l,m,n) select * from t ;

alter table t2 add constraint primary key(i);

insert into t1 (i,j, k,l,m,n) select * from t2 ;

alter table t1 add constraint primary key(j);

insert into t (j,i, k,l,m,n) select t1.i,t2.j,t1.k,t2.l,t1.m,t2.n from t1,t2 where t1.i=t2.i on duplicate key update i = i-1, k = k+1;

select * from t1 order by 1;

select * from t1 order by 1 desc;

drop table t,t1,t2;
