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
create index i_t1_a2q on t1(ATAN(a));
--TEST Create failed 
create index i_t1_a2p on t1(ATAN(b));
--TEST Create failed 
create index i_t1_a2o on t1(ATAN(c));
--TEST Create failed 
create index i_t1_a2n on t1(ATAN(d));
--TEST Create failed 
create index i_t1_a2m on t1(ATAN(e));
--TEST Create failed 
create index i_t1_a2l on t1(ATAN(f));
--TEST Create successfully 
create index i_t1_a2k on t1(ATAN(g));
--TEST: should use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where ATAN(g) is null ;
--TEST Create successfully 
create index i_t1_a2j on t1(ATAN(h));
--TEST: should use index i_t1_a2j
select /*+ RECOMPILE */* from t1 where ATAN(h)<=1.570796326794897e+00 ;
--TEST Create successfully 
create index i_t1_a2i on t1(ATAN(i));
--TEST: should use index i_t1_a2i
select /*+ RECOMPILE */* from t1 where ATAN(i)is null ;
--TEST Create successfully 
create index i_t1_a2h on t1(ATAN(j));
--TEST: should use index i_t1_a2h
select /*+ RECOMPILE */* from t1 where ATAN(j)=0.000000000000000e+00 ;
--TEST Create successfully 
create index i_t1_a2g on t1(ATAN(k));
--TEST: should use index i_t1_a2g
select /*+ RECOMPILE */* from t1 where ATAN(k)=-1.570796326794897e+00 ;
--TEST Create successfully 
create index i_t1_a2f on t1(ATAN(l));
--TEST: should use index i_t1_a2f
select /*+ RECOMPILE */* from t1 where ATAN(l)=0.000000000000000e+00 ;
--TEST Create successfully 
create index i_t1_a2e on t1(ATAN(m));
--TEST: should use index i_t1_a2e
select /*+ RECOMPILE */* from t1 where ATAN(m)is null ;
--TEST Create failed 
create index i_t1_a2d on t1(ATAN(n));
--TEST Create failed 
create index i_t1_a2c on t1(ATAN(o));
--TEST Create failed 
create index i_t1_a2b on t1(ATAN(p));
--TEST Create failed 
create index i_t1_a2a on t1(ATAN(q));




drop table t1;
commit;
--+ holdcas off;
