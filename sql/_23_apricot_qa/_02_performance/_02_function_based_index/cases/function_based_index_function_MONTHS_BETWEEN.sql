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
  DATE '2008-12-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(MONTHS_BETWEEN(a,n));
--TEST Create failed 
create index i_t1_a2p on t1(MONTHS_BETWEEN(b,n));
--TEST Create failed 
create index i_t1_a2o on t1(MONTHS_BETWEEN(c,n));
--TEST Create failed 
create index i_t1_a2n on t1(MONTHS_BETWEEN(d,n));
--TEST Create failed 
create index i_t1_a2m on t1(MONTHS_BETWEEN(e,n));
--TEST Create failed 
create index i_t1_a2l on t1(MONTHS_BETWEEN(f,n));
--TEST Create failed 
create index i_t1_a2k on t1(MONTHS_BETWEEN(g,n));
--TEST Create failed 
create index i_t1_a2j on t1(MONTHS_BETWEEN(h,n));
--TEST Create failed 
create index i_t1_a2i on t1(MONTHS_BETWEEN(i,n));
--TEST Create failed 
create index i_t1_a2h on t1(MONTHS_BETWEEN(j,n));
--TEST Create failed 
create index i_t1_a2g on t1(MONTHS_BETWEEN(k,n));
--TEST Create failed 
create index i_t1_a2f on t1(MONTHS_BETWEEN(l,n));
--TEST Create failed 
create index i_t1_a2e on t1(MONTHS_BETWEEN(m,n));
--TEST Create successfully  
create index i_t1_a2d on t1(MONTHS_BETWEEN(n,date '2010-6-30'));
--TEST: should use index i_t1_a2d
select /*+ RECOMPILE */* from t1 where MONTHS_BETWEEN(n,date '2010-6-30')= -1.800000000000000e+001 ;
--TEST Create failed  
create index i_t1_a2c on t1(MONTHS_BETWEEN(o,n));
--TEST Create failed  
create index i_t1_a2b on t1(MONTHS_BETWEEN(p,n));
--TEST Create failed 
create index i_t1_a2b on t1(MONTHS_BETWEEN(CAST(p AS DATE),n)) ;
--TEST Create failed  
create index i_t1_a2a on t1(MONTHS_BETWEEN(q,n));
--TEST Create failed  
create index i_t1_a2a on t1(MONTHS_BETWEEN(CAST(q AS DATE)),n) ;
drop table t1;
commit;
--+ holdcas off;
