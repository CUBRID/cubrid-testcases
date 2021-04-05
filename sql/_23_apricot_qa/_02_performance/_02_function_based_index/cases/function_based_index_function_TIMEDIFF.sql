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
  TIME '17:18:19',
  TIMESTAMP '2010-01-01 06:53:45',
  DATETIME  '2010-01-01 06:53:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(TIMEDIFF(a,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2p on t1(TIMEDIFF(b,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2o on t1(TIMEDIFF(c,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2n on t1(TIMEDIFF(d,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2m on t1(TIMEDIFF(e,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2l on t1(TIMEDIFF(f,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2k on t1(TIMEDIFF(g,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2j on t1(TIMEDIFF(h,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2i on t1(TIMEDIFF(i,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2h on t1(TIMEDIFF(j,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2g on t1(TIMEDIFF(k,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2f on t1(TIMEDIFF(l,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2e on t1(TIMEDIFF(m,time '12:05:52'));
--TEST Create failed   
create index i_t1_a2d on t1(TIMEDIFF(n,o));
--TEST Create failed   
create index i_t1_a2d on t1(TIMEDIFF(n,p));
--TEST Create failed   
create index i_t1_a2d on t1(TIMEDIFF(n,q));
--TEST Create successfully   
create index i_t1_a2d on t1(TIMEDIFF(n,DATE '2008-10-29'));
--TEST: should use index i_t1_a2d
select /*+ RECOMPILE */* from t1 where TIMEDIFF(n,DATE '2008-10-29') is null ;
--TEST Create failed 
create index i_t1_a2c on t1(TIMEDIFF(o,p));
--TEST Create failed 
create index i_t1_a2c on t1(TIMEDIFF(o,q));
--TEST Create successfully  
create index i_t1_a2c on t1(TIMEDIFF(o,time'12:05:52'));
--TEST: should use index i_t1_a2c
select /*+ RECOMPILE */* from t1 where TIMEDIFF(o,time'12:05:52')=time'05:12:27 AM' ;
--TEST Create failed  
create index i_t1_a2b on t1(TIMEDIFF(p,q));
--TEST Create successfully  
create index i_t1_a2b on t1(TIMEDIFF(p,Timestamp'2010-01-01 03:04:05'));
--TEST: should use index i_t1_a2b
select /*+ RECOMPILE */* from t1 where TIMEDIFF(p)>=time'03:49:40 AM' ;
--TEST Create failed  
create index i_t1_a2a on t1(TIMEDIFF(q,'2010-01-01 03:04:05'));
--TEST Create failed  
create index i_t1_a2a on t1(TIMEDIFF(q,Timestamp'2010-01-01 03:04:05'));
--TEST Create successfully  
create index i_t1_a2a on t1(TIMEDIFF(q,DATETIME'2010-01-01 03:04:05'));
--TEST: should use index i_t1_a2a
select /*+ RECOMPILE */* from t1 where TIMEDIFF(q) <='03:49:40 AM' ;
drop table t1;
commit;
--+ holdcas off;
