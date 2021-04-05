--+ holdcas on;
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '1234567890',
  '1234567890',
  N'abc',
  N'ABC',
  B'1111111111',
  B'1111111111',
  1234567890,
  -1,
  1234567890,
  -1,
  -1.5,
  -1.1,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(FROM_UNIXTIME(a));
--TEST Create failed 
create index i_t1_a2p on t1(FROM_UNIXTIME(b));
--TEST Create failed 
create index i_t1_a2o on t1(FROM_UNIXTIME(c));
--TEST Create failed 
create index i_t1_a2n on t1(FROM_UNIXTIME(d));
--TEST Create failed 
create index i_t1_a2m on t1(FROM_UNIXTIME(e));
--TEST Create failed 
create index i_t1_a2l on t1(FROM_UNIXTIME(f));
--TEST Create successfully 
create index i_t1_a2k on t1(FROM_UNIXTIME(g));
--TEST: should use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where FROM_UNIXTIME(g) ='01:31:30 AM 02/14/2009' ;
--TEST: should not use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where FROM_UNIXTIME(g) =DATETIME'01:31:30 AM 02/14/2009' ;
--TEST Create failed 
create index i_t1_a2j on t1(FROM_UNIXTIME(h));
--TEST: should use index i_t1_a2j
--select /*+ RECOMPILE */* from t1 where FROM_UNIXTIME(h)is not null ;
--TEST Create failed 
create index i_t1_a2i on t1(FROM_UNIXTIME(i,'%M %Y %W'));
--TEST: should use index i_t1_a2i
--select /*+ RECOMPILE */* from t1 where FROM_UNIXTIME(i,'%M %Y %W')=DATETIME'01:31:30 AM 02/14/2009' ;
--TEST Create failed 
create index i_t1_a2h on t1(FROM_UNIXTIME(j));
--TEST: should use index i_t1_a2h
--select /*+ RECOMPILE */* from t1 where FROM_UNIXTIME(j)is null ;
--TEST Create failed 
create index i_t1_a2g on t1(FROM_UNIXTIME(k));
--TEST: should use index i_t1_a2g
--select /*+ RECOMPILE */* from t1 where FROM_UNIXTIME(k)is null ;
--TEST Create failed 
create index i_t1_a2f on t1(FROM_UNIXTIME(l));
--TEST: should use index i_t1_a2f
--select /*+ RECOMPILE */* from t1 where FROM_UNIXTIME(l)=is null ;
--TEST Create failed 
create index i_t1_a2e on t1(FROM_UNIXTIME(m));
--TEST: should use index i_t1_a2e
--select /*+ RECOMPILE */* from t1 where FROM_UNIXTIME(m)is null ;
--TEST Create failed 
create index i_t1_a2d on t1(FROM_UNIXTIME(n));
--TEST Create failed 
create index i_t1_a2c on t1(FROM_UNIXTIME(o));
--TEST Create failed 
create index i_t1_a2b on t1(FROM_UNIXTIME(p));
--TEST Create failed 
create index i_t1_a2a on t1(FROM_UNIXTIME(q));


drop table t1;
commit;
--+ holdcas off;
