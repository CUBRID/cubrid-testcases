--+ holdcas on;
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
create index i_t1_a2q on t1(log10(a));
--TEST Create failed 
create index i_t1_a2p on t1(log10(b));
--TEST Create failed 
create index i_t1_a2o on t1(log10(c));
--TEST Create failed 
create index i_t1_a2n on t1(log10(d));
--TEST Create failed 
create index i_t1_a2m on t1(log10(e));
--TEST Create failed 
create index i_t1_a2l on t1(log10(f));
--TEST Create successfully 
create index i_t1_a2k on t1(log10(g));
--TEST: should use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where log10(g)<0 ;
--TEST Create successfully 
create index i_t1_a2j on t1(log10(h));
--TEST: should use index i_t1_a2j
select /*+ RECOMPILE */* from t1 where log10(h)<=1.000000000000000e+00 ;
--TEST Create successfully 
create index i_t1_a2i on t1(log10(i));
--TEST: should use index i_t1_a2i
select /*+ RECOMPILE */* from t1 where log10(i) <=1 ;
--TEST Create successfully 
create index i_t1_a2h on t1(log10(j));
--TEST: should use index i_t1_a2h
select /*+ RECOMPILE */* from t1 where log10(j)=0.000000000000000e+00  ;
--TEST Create successfully 
create index i_t1_a2g on t1(log10(k));
--TEST: should use index i_t1_a2g
select /*+ RECOMPILE */* from t1 where log10(k)is null ;
--TEST Create successfully 
create index i_t1_a2f on t1(log10(l));
--TEST: should use index i_t1_a2f
select /*+ RECOMPILE */* from t1 where log10(l)<0 ;
--TEST Create successfully 
create index i_t1_a2e on t1(log10(m));
--TEST: should use index i_t1_a2e
select /*+ RECOMPILE */* from t1 where log10(m) is null ;
--TEST Create failed 
create index i_t1_a2d on t1(log10(n));
--TEST Create failed 
create index i_t1_a2c on t1(log10(o));
--TEST Create failed 
create index i_t1_a2b on t1(log10(p));
--TEST Create failed 
create index i_t1_a2a on t1(log10(q));
--TEST Create failed 
create index i_t1_a2a1 on t1(log10(pi()/3));
--TEST Create failed 
create index i_t1_a2a2 on t1(log10(l/3));

drop table t1;
commit;
--+ holdcas off;
