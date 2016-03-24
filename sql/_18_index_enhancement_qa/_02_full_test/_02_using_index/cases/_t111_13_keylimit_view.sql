--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int unique,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME)
PARTITION BY RANGE (g)
(PARTITION before_10 VALUES LESS THAN (10),
PARTITION before_20 VALUES LESS THAN (20),
PARTITION before_10000 VALUES LESS THAN (10000));

insert into t1 values (
  '1234567890',
  '1234567890',
  N'abc',
  N'ABC',
  B'1111111111',
  B'1111111111',
  9,
  255,
  9223372036854775807,
  0,
  0,
  0,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');

create index idx_t1_all on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q);

insert into t1 select a,b,c,d,e,f,g+10,h,i,j,k,l,m,n,o,p,q from t1 where a is not null using index idx_t1_all keylimit 1,1;
insert into t1 select a,b,c,d,e,f,g+100,h,i,j,k,l,m,n,o,p,q from t1 where a is not null using index idx_t1_all keylimit 1,2;
insert into t1 select a,b,c,d,e,f,g+1000,h,i,j,k,l,m,n,o,p,q from t1 where a is not null using index idx_t1_all keylimit 1,4;

create view v as select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where a is not null using index idx_t1_all keylimit 1,1;
alter view v add query select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where a is not null using index idx_t1_all keylimit 2,2;
alter view v add query select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where a is not null using index idx_t1_all keylimit 3,3;
alter view v add query select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where a is not null using index idx_t1_all keylimit 4,4;
alter view v add query select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where a is not null using index idx_t1_all keylimit 5,5;
alter view v add query select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where a is not null using index idx_t1_all keylimit 6,6;
alter view v add query select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where a is not null using index idx_t1_all keylimit 7,7;
alter view v add query select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where a is not null using index idx_t1_all keylimit 8,8;

--TEST:
select /*+ recompile */ * from v where a is not null order by g asc;

drop view v;
drop table t1;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
