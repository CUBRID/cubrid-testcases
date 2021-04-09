--+ holdcas on;
create table t1(a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '1970-01-02',
  '2010-12-31 12:00:00',
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
  DATE '1970-01-02',
  TIME '00:00:00',
  TIMESTAMP '1970-01-02 00:00:00',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create successfully 
create index i_t1_a2q on t1(UNIX_TIMESTAMP(a));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where UNIX_TIMESTAMP(a)<540000 ;
--TEST Create successfully 
create index i_t1_a2p on t1(UNIX_TIMESTAMP(b));
--TEST Create failed 
create index i_t1_a2o on t1(UNIX_TIMESTAMP(c));
--TEST Create failed 
create index i_t1_a2n on t1(UNIX_TIMESTAMP(d));
--TEST Create failed 
create index i_t1_a2m on t1(UNIX_TIMESTAMP(e));
--TEST Create failed 
create index i_t1_a2l on t1(UNIX_TIMESTAMP(f));
--TEST Create failed 
create index i_t1_a2k on t1(UNIX_TIMESTAMP(g));
--TEST Create failed 
create index i_t1_a2j on t1(UNIX_TIMESTAMP(h));
--TEST Create failed 
create index i_t1_a2i on t1(UNIX_TIMESTAMP(i));
--TEST Create failed 
create index i_t1_a2h on t1(UNIX_TIMESTAMP(j));
--TEST Create failed 
create index i_t1_a2g on t1(UNIX_TIMESTAMP(k));
--TEST Create failed 
create index i_t1_a2f on t1(UNIX_TIMESTAMP(l));
--TEST Create failed 
create index i_t1_a2e on t1(UNIX_TIMESTAMP(m));
--TEST Create successfully  
create index i_t1_a2d on t1(UNIX_TIMESTAMP(n));
--TEST: should use index i_t1_a2d
select /*+ RECOMPILE */* from t1 where UNIX_TIMESTAMP(n)<=540000 ;
--TEST Create failed  
create index i_t1_a2c on t1(UNIX_TIMESTAMP(o));
--TEST Create successfully  
create index i_t1_a2b on t1(UNIX_TIMESTAMP(p));
--TEST: should use index i_t1_a2b
select /*+ RECOMPILE */* from t1 where UNIX_TIMESTAMP(p)>=540000 ;
--TEST Create successfully  
create index i_t1_a2a on t1(UNIX_TIMESTAMP(q));
select /*+ RECOMPILE */* from t1 where UNIX_TIMESTAMP(q)>=540000 ;
drop table t1;
commit;
--+ holdcas off;
