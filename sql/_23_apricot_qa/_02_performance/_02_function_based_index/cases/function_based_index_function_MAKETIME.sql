--+ holdcas on;
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '1234567890',
  '1234567890',
  N'abc',
  N'ABC',
  B'1111111111',
  B'1111111111',
  13,
  24,
  9223372036854775807,
  4,
  -1234.5678,
  -1234.5678,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(MAKETIME(a,0,0));
--TEST Create failed 
create index i_t1_a2p on t1(MAKETIME(b,0,0));
--TEST Create failed 
create index i_t1_a2o on t1(MAKETIME(c,0,0));
--TEST Create failed 
create index i_t1_a2n on t1(MAKETIME(d,0,0));
--TEST Create failed 
create index i_t1_a2m on t1(MAKETIME(e,0,0));
--TEST Create failed 
create index i_t1_a2l on t1(MAKETIME(f,0,0));
--TEST Create successfully 
create index i_t1_a2k on t1(MAKETIME(g,g,g));
--TEST: should use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where MAKETIME(g,g,g)=time'01:13:13 PM' ;
--TEST Create successfully 
create index i_t1_a2j on t1(MAKETIME(g,13,13));
--TEST: should use index i_t1_a2j
select /*+ RECOMPILE */* from t1 where MAKETIME(g,13,13)<time'01:34:04 PM' ;
--TEST Create successfully 
create index i_t1_a2i on t1(MAKETIME(13,g,13));
--TEST: should use index i_t1_a2i
select /*+ RECOMPILE */* from t1 where MAKETIME(13,g,13)<time'01:34:04 PM' ;
--TEST Create successfully 
create index i_t1_a2h on t1(MAKETIME(13,13,g));
--TEST: should use index i_t1_a2h
select /*+ RECOMPILE */* from t1 where MAKETIME(13,13,g)>=time'04:00:00 AM' ;
--TEST Create successfully 
create index i_t1_a2g on t1(MAKETIME(g,g,13));
--TEST: should use index i_t1_a2g
select /*+ RECOMPILE */* from t1 where MAKETIME(g,g,13)<time'01:34:04 PM' ;
--TEST Create successfully 
create index i_t1_a2f on t1(MAKETIME(13,g,g));
--TEST: should use index i_t1_a2f
select /*+ RECOMPILE */* from t1 where MAKETIME(13,g,g)>=time'04:00:00 AM' ;
--TEST Create successfully 
create index i_t1_a2e on t1(MAKETIME(g,13,g));
--TEST: should use index i_t1_a2e
select /*+ RECOMPILE */* from t1 where MAKETIME(g,13,g)>=time'04:00:00 AM' ;
--TEST Create failed 
create index i_t1_a2d on t1(MAKETIME(n,0,0));
--TEST Create failed 
create index i_t1_a2c on t1(MAKETIME(o,0,0));
--TEST Create failed 
create index i_t1_a2b on t1(MAKETIME(p,0,0));
--TEST Create failed 
create index i_t1_a2a on t1(MAKETIME(q,0,0));

drop table t1;
commit;
--+ holdcas off;
