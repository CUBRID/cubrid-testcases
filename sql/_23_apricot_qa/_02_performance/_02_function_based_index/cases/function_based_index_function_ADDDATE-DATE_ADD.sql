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
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(ADDDATE(a,0));
--TEST Create failed 
create index i_t1_a2p on t1(ADDDATE(b,0));
--TEST Create failed 
create index i_t1_a2o on t1(ADDDATE(c,0));
--TEST Create failed 
create index i_t1_a2n on t1(ADDDATE(d,0));
--TEST Create failed 
create index i_t1_a2m on t1(ADDDATE(e,0));
--TEST Create failed 
create index i_t1_a2l on t1(DATE_ADD(f,0));
--TEST Create failed 
create index i_t1_a2k on t1(ADDDATE(g,0));
--TEST Create failed 
create index i_t1_a2j on t1(ADDDATE(h,-1));
--TEST Create failed 
create index i_t1_a2i on t1(ADDDATE(i,0));
--TEST Create failed 
create index i_t1_a2h on t1(ADDDATE(j,0));
--TEST Create failed 
create index i_t1_a2g on t1(ADDDATE(k,3));
--TEST Create failed 
create index i_t1_a2f on t1(ADDDATE(l,g));
--TEST Create failed 
create index i_t1_a2e on t1(DATE_ADD(m,0));
--TEST Create successfully  
create index i_t1_a2d on t1(ADDDATE(n,g));
--TEST: should use index i_t1_a2d
select /*+ RECOMPILE */* from t1 where ADDDATE(n,g)=DATE '2008-11-10' ;
--TEST Create successfully  
create index i_t1_a2c on t1(ADDDATE(o,INTERVAL '1:20' HOUR_SECOND));
--TEST: should use index i_t1_a2c
select /*+ RECOMPILE */* from t1 where ADDDATE(o,INTERVAL '1:20' HOUR_SECOND)<=TIME '01:20:00' ;
--TEST Create successfully  
create index i_t1_a2b on t1(DATE_ADD(p,INTERVAL m HOUR));
--TEST: should use index i_t1_a2b
select /*+ RECOMPILE */* from t1 where DATE_ADD(p,INTERVAL m HOUR)>=  TIMESTAMP '2010-10-30 01:15:45' ;
--TEST Create successfully  
create index i_t1_a2a on t1(ADDDATE(q,INTERVAL g HOUR));
--TEST: should use index i_t1_a2a
select /*+ RECOMPILE */* from t1 where ADDDATE(q,INTERVAL g HOUR)) = DATETIME  '2008-10-31 23:15:45' ;
drop table t1;
commit;
--+ holdcas off;
