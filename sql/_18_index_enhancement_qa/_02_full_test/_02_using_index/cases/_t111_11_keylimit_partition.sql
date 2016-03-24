--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int unique,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME)
PARTITION BY RANGE (g)
(PARTITION before_10 VALUES LESS THAN (10),
PARTITION before_20 VALUES LESS THAN (20));

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

insert into t1 select a,b,c,d,e,f,g+10 g,h,i,j,k,l,m,n,o,p,q from t1 where a > '' using index idx_t1_all keylimit 1,1;
insert into t1 select a,b,c,d,e,f,g+100 g,h,i,j,k,l,m,n,o,p,q from t1 where a >'' using index idx_t1_all keylimit 2,2;
insert into t1 select a,b,c,d,e,f,g+1000 g,h,i,j,k,l,m,n,o,p,q from t1 where a > '' using index idx_t1_all keylimit 3,3;

--TEST: 
select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where a > '';

drop table t1;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
