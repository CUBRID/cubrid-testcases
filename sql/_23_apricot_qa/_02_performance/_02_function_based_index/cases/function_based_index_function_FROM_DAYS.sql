--+ holdcas on;
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '1234567890',
  '1234567890',
  N'abc',
  N'ABC',
  B'1111111111',
  B'1111111111',
  719528,
  0,
  9223372036854775807,
  0,
  -1,
  0,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(FROM_DAYS(a));
--TEST Create failed 
create index i_t1_a2p on t1(FROM_DAYS(b));
--TEST Create failed 
create index i_t1_a2o on t1(FROM_DAYS(c));
--TEST Create failed 
create index i_t1_a2n on t1(FROM_DAYS(d));
--TEST Create failed 
create index i_t1_a2m on t1(FROM_DAYS(e));
--TEST Create failed 
create index i_t1_a2l on t1(FROM_DAYS(f));
--TEST Create successfully 
create index i_t1_a2k on t1(FROM_DAYS(g));
--TEST: should use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where FROM_DAYS(g) <=DATE'01/01/1970' ;
--TEST Create failed 
create index i_t1_a2j on t1(FROM_DAYS(h));
--TEST: should use index i_t1_a2j
--select /*+ RECOMPILE */* from t1 where FROM_DAYS(h)<=DATE'01/01/0001' ;
--TEST Create failed 
create index i_t1_a2i on t1(FROM_DAYS(i));
--TEST: should use index i_t1_a2i
--select /*+ RECOMPILE */* from t1 where FROM_DAYS(i)is null ;
--TEST Create failed 
create index i_t1_a2h on t1(FROM_DAYS(j));
--TEST: should use index i_t1_a2h
--select /*+ RECOMPILE */* from t1 where FROM_DAYS(j)=DATE'01/01/0001' ;
--TEST Create failed 
create index i_t1_a2g on t1(FROM_DAYS(k));
--TEST: should use index i_t1_a2g
--select /*+ RECOMPILE */* from t1 where FROM_DAYS(k)is null ;
--TEST Create failed 
create index i_t1_a2f on t1(FROM_DAYS(l));
--TEST: should use index i_t1_a2f
--select /*+ RECOMPILE */* from t1 where FROM_DAYS(l)=DATE'01/01/0001' ;
--TEST Create failed 
create index i_t1_a2e on t1(FROM_DAYS(m));
--TEST: should use index i_t1_a2e
--select /*+ RECOMPILE */* from t1 where FROM_DAYS(m)is null ;
--TEST Create failed 
create index i_t1_a2d on t1(FROM_DAYS(n));
--TEST Create failed 
create index i_t1_a2c on t1(FROM_DAYS(o));
--TEST Create failed 
create index i_t1_a2b on t1(FROM_DAYS(p));
--TEST Create failed 
create index i_t1_a2a on t1(FROM_DAYS(q));


drop table t1;
commit;
--+ holdcas off;
