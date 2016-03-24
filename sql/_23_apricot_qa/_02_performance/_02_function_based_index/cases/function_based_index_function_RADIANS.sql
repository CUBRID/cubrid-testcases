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
  90,
  180,
  9223372036854775807,
  360,
  -1234.56789,
  1234.56789,
  0,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(RADIANS(a));
--TEST Create failed 
create index i_t1_a2p on t1(RADIANS(b));
--TEST Create failed 
create index i_t1_a2o on t1(RADIANS(c));
--TEST Create failed 
create index i_t1_a2n on t1(RADIANS(d));
--TEST Create failed 
create index i_t1_a2m on t1(RADIANS(e));
--TEST Create failed 
create index i_t1_a2l on t1(RADIANS(f));
--TEST Create successfully 
create index i_t1_a2k on t1(RADIANS(g));
--TEST: should use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where RADIANS(g) = 1.570796326794897e+00 ;
--TEST Create successfully 
create index i_t1_a2j on t1(RADIANS(h));
--TEST: should use index i_t1_a2j
select /*+ RECOMPILE */* from t1 where RADIANS(h)>=3.141592653589793e+00 ;
--TEST Create successfully 
create index i_t1_a2i on t1(RADIANS(i));
--TEST: should use index i_t1_a2i
select /*+ RECOMPILE */* from t1 where RADIANS(i)<=0 ;
--TEST Create successfully 
create index i_t1_a2h on t1(RADIANS(j));
--TEST: should use index i_t1_a2h
select /*+ RECOMPILE */* from t1 where RADIANS(j)<=6.283185307179586e+00 ;
--TEST Create successfully 
create index i_t1_a2g on t1(RADIANS(k));
--TEST: should use index i_t1_a2g
select /*+ RECOMPILE */* from t1 where RADIANS(k)>0 ;
--TEST Create successfully 
create index i_t1_a2f on t1(RADIANS(l));
--TEST: should use index i_t1_a2f
select /*+ RECOMPILE */* from t1 where RADIANS(l)>1 ;
--TEST Create successfully 
create index i_t1_a2e on t1(RADIANS(m));
--TEST: should use index i_t1_a2e
select /*+ RECOMPILE */* from t1 where RADIANS(m)=0 ;
--TEST Create failed 
create index i_t1_a2d on t1(RADIANS(n));
--TEST Create failed 
create index i_t1_a2c on t1(RADIANS(o));
--TEST Create failed 
create index i_t1_a2b on t1(RADIANS(p));
--TEST Create failed 
create index i_t1_a2a on t1(RADIANS(q));
--TEST Create failed 
create index i_t1_a2a1 on t1(RADIANS(pi()/3));
--TEST Create failed 
create index i_t1_a2a2 on t1(RADIANS(h/3));

drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
