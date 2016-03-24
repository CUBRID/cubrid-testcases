--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '1234567890',
  '1234567890',
  N'abc',
  N'ABC',
  B'1111111111',
  B'1111111111',
  10,
  1,
  9223372036854775807,
  0,
  -1,
  0,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(asin(a));
--TEST Create failed 
create index i_t1_a2p on t1(asin(b));
--TEST Create failed 
create index i_t1_a2o on t1(asin(c));
--TEST Create failed 
create index i_t1_a2n on t1(asin(d));
--TEST Create failed 
create index i_t1_a2m on t1(asin(e));
--TEST Create failed 
create index i_t1_a2l on t1(asin(f));
--TEST Create successfully 
create index i_t1_a2k on t1(asin(g));
--TEST: should use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where asin(g) is null ;
--TEST Create successfully 
create index i_t1_a2j on t1(asin(h));
--TEST: should use index i_t1_a2j
select /*+ RECOMPILE */* from t1 where asin(h)<=1.570796326794897e+00 ;
--TEST Create successfully 
create index i_t1_a2i on t1(asin(i));
--TEST: should use index i_t1_a2i
select /*+ RECOMPILE */* from t1 where asin(i)is null ;
--TEST Create successfully 
create index i_t1_a2h on t1(asin(j));
--TEST: should use index i_t1_a2h
select /*+ RECOMPILE */* from t1 where asin(j)=0.000000000000000e+00 ;
--TEST Create successfully 
create index i_t1_a2g on t1(asin(k));
--TEST: should use index i_t1_a2g
select /*+ RECOMPILE */* from t1 where asin(k)=-1.570796326794897e+00 ;
--TEST Create successfully 
create index i_t1_a2f on t1(asin(l));
--TEST: should use index i_t1_a2f
select /*+ RECOMPILE */* from t1 where asin(l)=0.000000000000000e+00 ;
--TEST Create successfully 
create index i_t1_a2e on t1(asin(m));
--TEST: should use index i_t1_a2e
select /*+ RECOMPILE */* from t1 where asin(m)is null ;
--TEST Create failed 
create index i_t1_a2d on t1(asin(n));
--TEST Create failed 
create index i_t1_a2c on t1(asin(o));
--TEST Create failed 
create index i_t1_a2b on t1(asin(p));
--TEST Create failed 
create index i_t1_a2a on t1(asin(q));




drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
