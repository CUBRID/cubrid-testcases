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
--test
create index i_t1_g1 on t1(log10(l) desc);
insert into t1 values (
  '1234567890',
  'SQL',
  N'abc',
  N'ABC',
  B'1111111111',
  B'1111111111',
  10,
  255,
  9223372036854775807,
  0,
  0,
  100,
  100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
  insert into t1 values (
  '1234567890',
  'ABC',
  N'abc',
  N'ABC',
  B'1111111111',
  B'1111111111',
  10,
  255,
  9223372036854775807,
  0,
  0,
  1000,
  100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
    insert into t1 values (
  '1234567890',
  'bcd',
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
  100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');

--TEST: should not use index i_t1_a
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where lower(b)>'0'
  group by a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q ;

  --TEST: should not use index i_t1_a
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where lower(b)>'0'
  group by a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q limit 1,2;
  
--TEST: should not use index i_t1_a
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where lower(b)>'0'
  group by lower(b) asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc ;
  --TEST: should not use index i_t1_a
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where lower(b)>'0'
  group by lower(b) asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc limit 1,2;

--TEST: should use index i_t1_a
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where lower(b) like 'a%'
  group by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc ;

--TEST: should use index i_t1_a
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where lower(b) in ('abc', 'bgc')
  group by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc ;


--TEST: should use index i_t1_a
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where exists (select 1 from db_root) and lower(b)>'0'
  group by a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q ;

--TEST: should use index i_t1_a or i_t1_g
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where lower(b) = 'abc'  
  and (log10(l) between 0 and 65535) and log10(l) in (1,2,3) 
  and b > '000000000' 
  and e < B'11111111111111111111' 
  and f >= B'000000000'  
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
  and q=DATETIME  '2008-10-31 13:15:45'
  group by a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q ;

--TEST: should use index i_t1_g
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where log10(l) = any {9,1, 11}
  and log10(l) = all{1}
  and log10(l) = some{9,1,11}
  group by a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q ;

drop table t1;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
