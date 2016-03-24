drop table if exists t1;
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

-- the index should be created successfully
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

create index i_t1_abcdefghijklmnopq1 on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q)
  where a = '1234567890'  
  and b > '000000000'  
  and (g between 0 and 65535)
  and h<>0 
  and h<>0;

  
  show index in t1;
  drop table t1;
