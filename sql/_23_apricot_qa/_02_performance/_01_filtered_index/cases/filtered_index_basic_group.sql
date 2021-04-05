--+ holdcas on;
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
create index i_t1_abcdefghijklmnopq on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q) where a is not null;
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
  0,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  group by a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q using index i_t1_abcdefghijklmnopq(+);

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
 where a is not null
  group by a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q using index i_t1_abcdefghijklmnopq(+);
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
 where a is not null
  group by a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q using index i_t1_abcdefghijklmnopq;
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
 where a is not null
  group by a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q ;
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  group by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc using index i_t1_abcdefghijklmnopq(+);

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
 where a is not null
  group by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc using index i_t1_abcdefghijklmnopq(+);
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
 where a is not null
  group by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc using index i_t1_abcdefghijklmnopq;

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a like '12345%'
  group by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc using index i_t1_abcdefghijklmnopq(+);
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a like '12345%'
  group by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc;

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a in ('1234567890', '00000000')
  group by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc using index i_t1_abcdefghijklmnopq(+);


select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where exists (select 1 from db_root)
  group by a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q using index i_t1_abcdefghijklmnopq(+);

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a = '1234567890'  
  and b > '000000000' 
  and e < B'11111111111111111111' 
  and f >= B'000000000'
  and (g between 0 and 65535) and g in (10) 
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
  group by a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q using index i_t1_abcdefghijklmnopq(+);
 drop index i_t1_abcdefghijklmnopq on t1;
  create index i_t1_abcdefghijklmnopq1 on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q)
  where a = '1234567890'  
  and b > '000000000' 
  and e < B'11111111111111111111' 
  and f >= B'000000000'
  and (g between 0 and 65535)
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
  and q=DATETIME  '2008-10-31 13:15:45';	
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a = '1234567890'  
  and b > '000000000' 
  and e < B'11111111111111111111' 
  and f >= B'000000000'
  and (g between 0 and 65535) 
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
  group by a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q using index i_t1_abcdefghijklmnopq(+);

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a = '1234567890'  
  and b > '000000000' 
  and e < B'11111111111111111111' 
  and f >= B'000000000'
  and (g between 0 and 65535) 
  and h<>0 
  and h<>0 
  and i>0 cu
  and j>-1 
  and k>-1 
  and l>-1 
  and m > -102
  and n>DATE '2000-01-01'
  and o = TIME '00:00:00' 
  and p<TIMESTAMP '2012-10-31 00:00:00'
  and q=DATETIME  '2008-10-31 13:15:45'
  group by a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q using index i_t1_abcdefghijklmnopq(+);

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where g = any {9,10, 11}
  and g = all{10}
  and g = some{9,10,11}
  group by a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q;

drop table t1;
   
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
  0,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
create index i_t1_abcdefghijklmnopq on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q) where a  like '12345%';

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a like '12345%'
  group by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc using index i_t1_abcdefghijklmnopq(+);

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a like '123456%'
  group by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc using index i_t1_abcdefghijklmnopq(+);

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a like '1234%'
  group by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc using index i_t1_abcdefghijklmnopq(+);

drop table t1;

commit;
--+ holdcas off;
