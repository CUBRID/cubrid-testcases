set system parameters 'deduplicate_key_level=0';

--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1(
  a char(1200), 
  b varchar(1200),
  c nchar(1200),
  d NCHAR VARYING(1200),
  e BIT(1200),
  f BIT VARYING(1200),
  g int,
  h SMALLINT,
  i BIGINT,
  j NUMERIC,
  k FLOAT,
  l DOUBLE,
  m MONETARY,
  n DATE,
  o TIME,
  p TIMESTAMP,
  q DATETIME
);
create index i_t1_a on t1(lower(b));
create index i_t1_g on t1(log10(l));
insert into t1 values (
  '1234567890',
  '1234567890',
  N'abc',
  N'ABC',
  B'1111111111',
  B'1111111111',
  10,
  255,
  9223372036854775807,
  0,
  0,
  10,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');

--TEST: should use index i_t1_a
select /*+ RECOMPILE */* from t1 
  where lower(b) = '1234567890' 
  order by a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q ;

--TEST: should use index i_t1_a
select /*+ RECOMPILE */* from t1 
  where lower(b) >= '1234567890' ;

--TEST: should use index i_t1_a
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where lower(b) like '12345%' ;

--TEST: should use index i_t1_a
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where lower(b) in ('1234567890', '00000000') ;

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where exists (select 1 from db_root) and lower(b) is not null ;

--TEST: should use index i_t1_a or i_t1_g
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where lower(b) >= '1234567890'  
  and b > '000000000' 
  and e < B'11111111111111111111' 
  and f >= B'000000000'
  and (log10(l) between 0 and 65535) and log10(l) in (1) 
  and h<>0 
  and h<>0 
  and i>0 
  and j>-1 
  and k>-1 
  and l>-1 
  and m > -101 
  and n>DATE '2000-01-01'
  and o = TIME '00:00:00' 
  and p<TIMESTAMP '2012-10-31 00:00:00'
  and q=DATETIME  '2008-10-31 13:15:45' ;

--TEST: should use index i_t1_g
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where log10(l) = any {-1,1, 10}
  and log10(l) = all{1}
  and log10(l) = some{9,1,11} ;

drop table t1;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

set system parameters 'deduplicate_key_level=10';
