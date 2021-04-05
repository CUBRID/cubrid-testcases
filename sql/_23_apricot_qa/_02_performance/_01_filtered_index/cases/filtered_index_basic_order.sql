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
 insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1  
   using index i_t1_abcdefghijklmnopq(+) order by a,b,c;

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1  
  where b ='1234567890'
  using index i_t1_abcdefghijklmnopq(+) order by a,b,c ;

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1  
  where a is not null
  using index i_t1_abcdefghijklmnopq(+) order by a,b,c ;

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  using index i_t1_abcdefghijklmnopq(+) order by a ,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q;


select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  using index i_t1_abcdefghijklmnopq(+) order by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc ;

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a = '1234567890'
  using index i_t1_abcdefghijklmnopq(+) order by a,b,c;

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a > '000'
  using index i_t1_abcdefghijklmnopq(+) order by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc;


select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a like '12345%'
  using index i_t1_abcdefghijklmnopq(+) order by a asc,b asc,c asc;

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a in ('1234567890', '00000000')
  using index i_t1_abcdefghijklmnopq(+) order by a asc,b asc,c asc;

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where exists (select 1 from db_root)
  using index i_t1_abcdefghijklmnopq(+) order by a asc,b asc,c asc ;


 drop index i_t1_abcdefghijklmnopq on t1;


create index i_t1_abcdefghijklmnopq on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q) where a > '000000000' ;

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a > '000'
  using index i_t1_abcdefghijklmnopq(+) order by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc ;
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a > '000'
  using index i_t1_abcdefghijklmnopq order by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc ;
select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a > '000000000'
  order by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc ;

select /*+ RECOMPILE */a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 
  where a > '100'
  using index i_t1_abcdefghijklmnopq(+) order by a asc,b asc,c asc,d asc,e asc,f asc,g asc,h asc,i asc,j asc,k asc,l asc,m asc,n asc,o asc,p asc,q asc;

drop table t1;

commit;
--+ holdcas off;
