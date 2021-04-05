--+ holdcas on;
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '1234567890',
  '1234567890',
  N'abc',
  N'ABC',
  B'1111111111',
  B'1111111111',
  2,
  8,
  9223372036854775807,
  1,
  0,
  1.1,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(ROUND(a,1));
--TEST Create failed 
create index i_t1_a2p on t1(ROUND(b,1));
--TEST Create failed 
create index i_t1_a2o on t1(ROUND(c,0));
--TEST Create failed 
create index i_t1_a2n on t1(ROUND(d,1));
--TEST Create failed 
create index i_t1_a2m on t1(ROUND(e,1));
--TEST Create failed 
create index i_t1_a2l on t1(ROUND(f,1));
--TEST Create successfully 
create index i_t1_a2k on t1(ROUND(g,1));
--TEST: should use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where ROUND(g,1)>0 ;
--TEST Create successfully 
create index i_t1_a2j on t1(ROUND(h,g));
--TEST: should use index i_t1_a2j
select /*+ RECOMPILE */* from t1 where ROUND(h,g)<=1 ;
--TEST Create successfully 
create index i_t1_a2i on t1(ROUND(i,g));
--TEST: should use index i_t1_a2i
select /*+ RECOMPILE */* from t1 where ROUND(i,g)<=1 ;
--TEST Create successfully 
create index i_t1_a2h on t1(ROUND(j,1));
--TEST: should use index i_t1_a2h
select /*+ RECOMPILE */* from t1 where ROUND(j,1)=0 ;
--TEST Create successfully 
create index i_t1_a2g on t1(ROUND(k,1));
--TEST: should use index i_t1_a2g
select /*+ RECOMPILE */* from t1 where ROUND(k,1)=0 ;
--TEST Create successfully 
create index i_t1_a2f on t1(ROUND(l,1));
--TEST: should use index i_t1_a2f
select /*+ RECOMPILE */* from t1 where ROUND(l,1)=1.0 ;
--TEST Create successfully 
create index i_t1_a2e on t1(ROUND(m,3));
--TEST: should use index i_t1_a2e
select /*+ RECOMPILE */* from t1 where ROUND(m,3)=0 ;
--TEST Create failed 
create index i_t1_a2d on t1(ROUND(n,1));
--TEST Create failed 
create index i_t1_a2c on t1(ROUND(o,1));
--TEST Create failed 
create index i_t1_a2b on t1(ROUND(p,1));
--TEST Create failed 
create index i_t1_a2a on t1(ROUND(q,1));
drop table t1;
commit;
--+ holdcas off;
