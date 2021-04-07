--+ holdcas on;
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
create index i_t1_a2q on t1(time_to_sec(a));
--TEST Create failed 
create index i_t1_a2p on t1(time_to_sec(b));
--TEST Create failed 
create index i_t1_a2o on t1(time_to_sec(c));
--TEST Create failed 
create index i_t1_a2n on t1(time_to_sec(d));
--TEST Create failed 
create index i_t1_a2m on t1(time_to_sec(e));
--TEST Create failed 
create index i_t1_a2l on t1(time_to_sec(f));
--TEST Create failed 
create index i_t1_a2k on t1(time_to_sec(g));
--TEST Create failed 
create index i_t1_a2j on t1(time_to_sec(h));
--TEST Create failed 
create index i_t1_a2i on t1(time_to_sec(i));
--TEST Create failed 
create index i_t1_a2h on t1(time_to_sec(j));
--TEST Create failed 
create index i_t1_a2g on t1(time_to_sec(k));
--TEST Create failed 
create index i_t1_a2f on t1(time_to_sec(l));
--TEST Create failed 
create index i_t1_a2e on t1(time_to_sec(m));
--TEST Create failed   
create index i_t1_a2d on t1(time_to_sec(n));
--TEST Create successfully  
create index i_t1_a2c on t1(time_to_sec(o));
--TEST: should use index i_t1_a2c
select /*+ RECOMPILE */* from t1 where time_to_sec(o) =9296;
--TEST Create successfully  
create index i_t1_a2b on t1(time_to_sec(p));
--TEST: should use index i_t1_a2b
select /*+ RECOMPILE */* from t1 where time_to_sec(p)>=9296 ;
--TEST Create successfully  
create index i_t1_a2a on t1(time_to_sec(q));
--TEST: should use index i_t1_a2a
select /*+ RECOMPILE */* from t1 where time_to_sec(q) <=9296 ;
drop table t1;
commit;
--+ holdcas off;
