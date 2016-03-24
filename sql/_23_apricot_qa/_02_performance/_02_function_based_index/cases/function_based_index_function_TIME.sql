--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1(a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

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
  1.5678,
  -12.5678,
  -24,
  DATE '2008-10-31',
  TIME '2:34:56',
  TIMESTAMP '2010-01-01 12:34:56',
  DATETIME  '2010-01-01 12:34:56');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(TIME(a));
--TEST Create failed 
create index i_t1_a2p on t1(TIME(b));
--TEST Create failed 
create index i_t1_a2o on t1(TIME(c));
--TEST Create failed 
create index i_t1_a2n on t1(TIME(d));
--TEST Create failed 
create index i_t1_a2m on t1(TIME(e));
--TEST Create failed 
create index i_t1_a2l on t1(TIME(f));
--TEST Create failed 
create index i_t1_a2k on t1(TIME(g));
--TEST Create failed 
create index i_t1_a2j on t1(TIME(h));
--TEST Create failed 
create index i_t1_a2i on t1(TIME(i));
--TEST Create failed 
create index i_t1_a2h on t1(TIME(j));
--TEST Create failed 
create index i_t1_a2g on t1(TIME(k));
--TEST Create failed 
create index i_t1_a2f on t1(TIME(l));
--TEST Create failed 
create index i_t1_a2e on t1(TIME(m));
--TEST Create failed   
create index i_t1_a2d on t1(TIME(n));
--TEST Create successfully  
create index i_t1_a2c on t1(TIME(o));
--TEST: should use index i_t1_a2c
select /*+ RECOMPILE */* from t1 where TIME(o)<'12:34:56.000' ;
--TEST Create successfully  
create index i_t1_a2b on t1(TIME(p));
--TEST: should use index i_t1_a2b
select /*+ RECOMPILE */* from t1 where TIME(p)>='12:34:56.000' ;
--TEST Create successfully  
create index i_t1_a2a on t1(TIME(q));
--TEST: should use index i_t1_a2a
select /*+ RECOMPILE */* from t1 where TIME(q) <='12:34:56.000' ;
drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
