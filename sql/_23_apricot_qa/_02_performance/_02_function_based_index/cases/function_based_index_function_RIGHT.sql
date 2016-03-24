--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
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
  0,
  0,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create successfully 
create index i_t1_a2q on t1(RIGHT(a,3));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where RIGHT(a,3)='890' ;
--TEST Create successfully 
create index i_t1_a2p on t1(RIGHT(b,g));
--TEST: should use index i_t1_a2p
select /*+ RECOMPILE */* from t1 where RIGHT(b,g)>'12345' ;
--TEST Create successfully 
create index i_t1_a2o on t1(RIGHT(c,3));
--TEST: should use index i_t1_a2o
select /*+ RECOMPILE */* from t1 where RIGHT(c,3)>=N'abc' ;
--TEST Create successfully 
create index i_t1_a2n on t1(RIGHT(d,4));
--TEST: should use index i_t1_a2n
select /*+ RECOMPILE */* from t1 where RIGHT(d,4)<N'ABCd' ;
--TEST Create failed
create index i_t1_a2m on t1(RIGHT(e,1));
--TEST Create failed
create index i_t1_a2l on t1(RIGHT(f,g));
--TEST Create failed
create index i_t1_a2k on t1(RIGHT(g,g));
--TEST Create failed
create index i_t1_a2j on t1(RIGHT(h.g));
--TEST Create failed
create index i_t1_a2i on t1(RIGHT(i,0));
--TEST Create failed
create index i_t1_a2h on t1(RIGHT(j,g));
--TEST Create failed
create index i_t1_a2g on t1(RIGHT(k,1));
--TEST Create failed
create index i_t1_a2f on t1(RIGHT(l,1));
--TEST Create failed
create index i_t1_a2e on t1(RIGHT(m,1));
--TEST Create failed 
create index i_t1_a2d on t1(RIGHT(n,g));
--TEST Create failed 
create index i_t1_a2c on t1(RIGHT(o,g));
--TEST Create failed 
create index i_t1_a2b on t1(RIGHT(p,g));
--TEST Create failed 
create index i_t1_a2a on t1(RIGHT(q,g));
--TEST Create failed
create index i_t1_a2 on t1(RIGHT(a,b));
--TEST Create failed
create index i_t1_a on t1(RIGHT(d,q));

drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
