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
  8,
  9223372036854775807,
  1,
  0,
  0.1,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(log2(a));
--TEST Create failed 
create index i_t1_a2p on t1(log2(b));
--TEST Create failed 
create index i_t1_a2o on t1(log2(c));
--TEST Create failed 
create index i_t1_a2n on t1(log2(d));
--TEST Create failed 
create index i_t1_a2m on t1(log2(e));
--TEST Create failed 
create index i_t1_a2l on t1(log2(f));
--TEST Create successfully 
create index i_t1_a2k on t1(log2(g));
--TEST: should use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where log2(g)<g ;
--TEST Create successfully 
create index i_t1_a2j on t1(log2(h));
--TEST: should use index i_t1_a2j
select /*+ RECOMPILE */* from t1 where log2(h)<=3.000000000000000e+00 ;
--TEST Create successfully 
create index i_t1_a2i on t1(log2(i));
--TEST: should use index i_t1_a2i
select /*+ RECOMPILE */* from t1 where log2(i) <=i ;
--TEST Create successfully 
create index i_t1_a2h on t1(log2(j));
--TEST: should use index i_t1_a2h
select /*+ RECOMPILE */* from t1 where log2(j)=0.000000000000000e+00  ;
--TEST Create successfully 
create index i_t1_a2g on t1(log2(k));
--TEST: should use index i_t1_a2g
select /*+ RECOMPILE */* from t1 where log2(k)is null ;
--TEST Create successfully 
create index i_t1_a2f on t1(log2(l));
--TEST: should use index i_t1_a2f
select /*+ RECOMPILE */* from t1 where log2(l)>0 ;
--TEST Create successfully 
create index i_t1_a2e on t1(log2(m));
--TEST: should use index i_t1_a2e
select /*+ RECOMPILE */* from t1 where log2(m) is null ;
--TEST Create failed 
create index i_t1_a2d on t1(log2(n));
--TEST Create failed 
create index i_t1_a2c on t1(log2(o));
--TEST Create failed 
create index i_t1_a2b on t1(log2(p));
--TEST Create failed 
create index i_t1_a2a on t1(log2(q));
--TEST Create failed 
create index i_t1_a2a1 on t1(log2(pi()/3));
--TEST Create failed 
create index i_t1_a2a2 on t1(log2(l/3));

drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
