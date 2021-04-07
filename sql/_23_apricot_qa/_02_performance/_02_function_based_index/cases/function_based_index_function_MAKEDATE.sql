--+ holdcas on;
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '1234567890',
  '1234567890',
  N'abc',
  N'ABC',
  B'1111111111',
  B'1111111111',
  277,
  10,
  9223372036854775807,
  -1,
  -1234.5678,
  -1234.5678,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(MAKEDATE(a,0));
--TEST Create failed 
create index i_t1_a2p on t1(MAKEDATE(b,0));
--TEST Create failed 
create index i_t1_a2o on t1(MAKEDATE(c,0));
--TEST Create failed 
create index i_t1_a2n on t1(MAKEDATE(d,0));
--TEST Create failed 
create index i_t1_a2m on t1(MAKEDATE(e,0));
--TEST Create failed 
create index i_t1_a2l on t1(MAKEDATE(f,0));
--TEST Create successfully 
create index i_t1_a2k on t1(MAKEDATE(g,g));
--TEST: should use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where MAKEDATE(g,g)=date'10/04/0277'  ;
--TEST Create successfully 
create index i_t1_a2j on t1(MAKEDATE(g,10));
--TEST: should use index i_t1_a2j
select /*+ RECOMPILE */* from t1 where MAKEDATE(g,10)=date'10/04/0277'  ;
--TEST Create successfully 
create index i_t1_a2i on t1(MAKEDATE(10,g));
--TEST: should use index i_t1_a2i
select /*+ RECOMPILE */* from t1 where MAKEDATE(10,g) =date'10/04/0277'  ;
--TEST Create failed 
create index i_t1_a2h on t1(MAKEDATE(j,0));
--TEST Create failed 
create index i_t1_a2g on t1(MAKEDATE(k,3));
--TEST Create failed 
create index i_t1_a2f on t1(MAKEDATE(l,2));
--TEST Create failed 
create index i_t1_a2e on t1(MAKEDATE(m,0));
--TEST Create failed 
create index i_t1_a2d on t1(MAKEDATE(n,0));
--TEST Create failed 
create index i_t1_a2c on t1(MAKEDATE(o,0));
--TEST Create failed 
create index i_t1_a2b on t1(MAKEDATE(p,0));
--TEST Create failed 
create index i_t1_a2a on t1(MAKEDATE(q,0));

drop table t1;
commit;
--+ holdcas off;
