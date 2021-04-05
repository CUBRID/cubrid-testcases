--+ holdcas on;
create table t1(a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '2009-12-31',
  '2010-12-31 12:00:00',
  N'2009-12-31',
  N'2009-12-31',
  B'1111111111',
  B'1111111111',
  10,
  255,
  9223372036854775807,
  0,
  1.5678,
  -12.5678,
  -24,
  DATE '2009-12-31',
  TIME '12:00:00',
  TIMESTAMP '2010-12-31 12:00:00',
  DATETIME  '2010-01-01 06:53:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(TIMESTAMP(a,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2p on t1(TIMESTAMP(b,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2o on t1(TIMESTAMP(c,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2n on t1(TIMESTAMP(d,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2m on t1(TIMESTAMP(e,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2l on t1(TIMESTAMP(f,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2k on t1(TIMESTAMP(g,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2j on t1(TIMESTAMP(h,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2i on t1(TIMESTAMP(i,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2h on t1(TIMESTAMP(j,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2g on t1(TIMESTAMP(k,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2f on t1(TIMESTAMP(l,time '12:05:52'));
--TEST Create failed 
create index i_t1_a2e on t1(TIMESTAMP(m,time '12:05:52'));
--TEST Create successfully   
create index i_t1_a2d on t1(TIMESTAMP(n,o));
--TEST: should use index i_t1_a2d
select /*+ RECOMPILE */* from t1 where TIMESTAMP(n,o)=DATETIME'12:00:00.000 AM 12/31/2009' ;
--TEST Create failed  
create index i_t1_a2c on t1(TIMESTAMP(o,time'12:05:52'));
--TEST Create failed  
create index i_t1_a2b on t1(TIMESTAMP(p,n));
--TEST Create failed  
create index i_t1_a2b on t1(TIMESTAMP(p,q));
--TEST Create failed  
create index i_t1_a2b on t1(TIMESTAMP(p,'12:00:00'));
--TEST Create successfully  
create index i_t1_a2b on t1(TIMESTAMP(p,time'12:00:00'));
--TEST: should use index i_t1_a2b
select /*+ RECOMPILE */* from t1 where TIMESTAMP(p)>=DATETIME'12:00:00.000 AM 01/01/2011' ;
--TEST Create failed  
create index i_t1_a2a on t1(TIMESTAMP(q,o));
drop table t1;
commit;
--+ holdcas off;
