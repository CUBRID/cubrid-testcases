--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1(a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '2009-12-31',
  '2010-12-31 12:00:00',
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
  DATE '2010-04-05',
  TIME '00:00:00',
  TIMESTAMP '2010-04-05 12:34:56',
  DATETIME  '2010-04-05 12:34:56.7890');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(WEEK(a));
--TEST Create failed 
create index i_t1_a2p on t1(WEEK(b));
--TEST Create failed 
create index i_t1_a2o on t1(WEEK(c));
--TEST Create failed 
create index i_t1_a2n on t1(WEEK(d));
--TEST Create failed 
create index i_t1_a2m on t1(WEEK(e));
--TEST Create failed 
create index i_t1_a2l on t1(WEEK(f));
--TEST Create failed 
create index i_t1_a2k on t1(WEEK(g));
--TEST Create failed 
create index i_t1_a2j on t1(WEEK(h));
--TEST Create failed 
create index i_t1_a2i on t1(WEEK(i));
--TEST Create failed 
create index i_t1_a2h on t1(WEEK(j));
--TEST Create failed 
create index i_t1_a2g on t1(WEEK(k));
--TEST Create failed 
create index i_t1_a2f on t1(WEEK(l));
--TEST Create failed 
create index i_t1_a2e on t1(WEEK(m));
--TEST Create successfully  
create index i_t1_a2d on t1(WEEK(n));
--TEST: should use index i_t1_a2d
select /*+ RECOMPILE */* from t1 where WEEK(n)=14 ;
create index i_t1_a2d1 on t1(WEEK(n,2));
--TEST: should use index i_t1_a2d1
select /*+ RECOMPILE */* from t1 where WEEK(n,2)=14 ;
--TEST Create failed  
create index i_t1_a2c on t1(WEEK(o));
--TEST Create successfully  
create index i_t1_a2b on t1(WEEK(p,2));
--TEST: should use index i_t1_a2b
select /*+ RECOMPILE */* from t1 where WEEK(p,2)>=14 ;
--TEST Create failed  
create index i_t1_a2a on t1(WEEK(q,8));
--TEST Create successfully  
create index i_t1_a2a on t1(WEEK(q,4));
--TEST: should use index i_t1_a2a
select /*+ RECOMPILE */* from t1 where WEEK(q,4)) <=14 ;
drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
