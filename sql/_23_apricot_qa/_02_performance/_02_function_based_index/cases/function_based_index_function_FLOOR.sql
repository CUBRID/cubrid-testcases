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
  255,
  9223372036854775807,
  0,
  1234.5678,
  -1234.5678,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(FLOOR(a));
--TEST Create failed 
create index i_t1_a2p on t1(FLOOR(b));
--TEST Create failed 
create index i_t1_a2o on t1(FLOOR(c));
--TEST Create failed 
create index i_t1_a2n on t1(FLOOR(d));
--TEST Create failed 
create index i_t1_a2m on t1(FLOOR(e));
--TEST Create failed 
create index i_t1_a2l on t1(FLOOR(f));
--TEST Create successfully 
create index i_t1_a2k on t1(FLOOR(g));
--TEST: should not use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where FLOOR(g)>=g ;
--TEST: should use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where FLOOR(g)>=10 ;
--TEST Create successfully 
create index i_t1_a2j on t1(FLOOR(h));
--TEST: should not use index i_t1_a2j
select /*+ RECOMPILE */* from t1 where FLOOR(h)>=h ;
--TEST: should use index i_t1_a2j
select /*+ RECOMPILE */* from t1 where FLOOR(h)>=0 ;
--TEST Create successfully 
create index i_t1_a2i on t1(FLOOR(i));
--TEST: should not use index i_t1_a2i
select /*+ RECOMPILE */* from t1 where FLOOR(i) is null ;
--TEST Create successfully 
create index i_t1_a2h on t1(FLOOR(j));
--TEST: should use index i_t1_a2h
select /*+ RECOMPILE */* from t1 where FLOOR(j)=0 ;
--TEST Create successfully 
create index i_t1_a2g on t1(FLOOR(k));
--TEST: should not use index i_t1_a2g
select /*+ RECOMPILE */* from t1 where FLOOR(k)<=k ;
--TEST: should use index i_t1_a2g
select /*+ RECOMPILE */* from t1 where FLOOR(k)<=10000 ;
--TEST Create successfully 
create index i_t1_a2f on t1(FLOOR(l));
--TEST: should use index i_t1_a2f
select /*+ RECOMPILE */* from t1 where FLOOR(l)>=1 ;
--TEST Create successfully 
create index i_t1_a2e on t1(FLOOR(m));
--TEST: should not use index i_t1_a2e
select /*+ RECOMPILE */* from t1 where FLOOR(m)<>m ;
--TEST Create failed 
create index i_t1_a2d on t1(FLOOR(n));
--TEST Create failed 
create index i_t1_a2c on t1(FLOOR(o));
--TEST Create failed 
create index i_t1_a2b on t1(FLOOR(p));
--TEST Create failed 
create index i_t1_a2a on t1(FLOOR(q));
--TEST Create failed 
create index i_t1_a2a1 on t1(FLOOR(pi()/3));
--TEST Create failed 
create index i_t1_a2a2 on t1(FLOOR(h/3));

drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
