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
  255,
  9223372036854775807,
  0,
  1.5678,
  -12.5678,
  -24,
  DATE '2008-10-31',
  TIME '01:20:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(SUBDATE(a,0));
--TEST Create failed 
create index i_t1_a2p on t1(SUBDATE(b,0));
--TEST Create failed 
create index i_t1_a2o on t1(SUBDATE(c,0));
--TEST Create failed 
create index i_t1_a2n on t1(SUBDATE(d,0));
--TEST Create failed 
create index i_t1_a2m on t1(SUBDATE(e,0));
--TEST Create failed 
create index i_t1_a2l on t1(DATE_SUB(f,0));
--TEST Create failed 
create index i_t1_a2k on t1(SUBDATE(g,0));
--TEST Create failed 
create index i_t1_a2j on t1(SUBDATE(h,-1));
--TEST Create failed 
create index i_t1_a2i on t1(SUBDATE(i,0));
--TEST Create failed 
create index i_t1_a2h on t1(SUBDATE(j,0));
--TEST Create failed 
create index i_t1_a2g on t1(SUBDATE(k,3));
--TEST Create failed 
create index i_t1_a2f on t1(SUBDATE(l,g));
--TEST Create failed 
create index i_t1_a2e on t1(DATE_SUB(m,0));
--TEST Create successfully  
create index i_t1_a2d on t1(SUBDATE(n,g));
--TEST: should use index i_t1_a2d
select /*+ RECOMPILE */* from t1 where SUBDATE(n,g)=DATE '2008-10-21' ;
--TEST Create successfully  
create index i_t1_a2c on t1(SUBDATE(o,INTERVAL '1:20' HOUR_SECOND));
--TEST: should use index i_t1_a2c
select /*+ RECOMPILE */* from t1 where SUBDATE(o,INTERVAL '1:20' HOUR_SECOND)<=TIME '00:00:00' ;
--TEST Create successfully  
create index i_t1_a2b on t1(DATE_SUB(p,INTERVAL m HOUR));
--TEST: should use index i_t1_a2b
select /*+ RECOMPILE */* from t1 where DATE_SUB(p,INTERVAL m HOUR)>=  TIMESTAMP '2010-11-01 01:15:45' ;
--TEST Create successfully  
create index i_t1_a2a on t1(SUBDATE(q,INTERVAL g HOUR));
--TEST: should use index i_t1_a2a
select /*+ RECOMPILE */* from t1 where SUBDATE(q,INTERVAL g HOUR)) = DATETIME  '2008-10-31 03:15:45' ;
drop table t1;
commit;
--+ holdcas off;
