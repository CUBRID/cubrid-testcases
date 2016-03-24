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
  1,
  9223372036854775807,
  0,
  -1234.56789,
  1234.56789,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(degrees(a));
--TEST Create failed 
create index i_t1_a2p on t1(degrees(b));
--TEST Create failed 
create index i_t1_a2o on t1(degrees(c));
--TEST Create failed 
create index i_t1_a2n on t1(degrees(d));
--TEST Create failed 
create index i_t1_a2m on t1(degrees(e));
--TEST Create failed 
create index i_t1_a2l on t1(degrees(f));
--TEST Create successfully 
create index i_t1_a2k on t1(degrees(g));
--TEST: should use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where degrees(g) <>0 ;
--TEST Create successfully 
create index i_t1_a2j on t1(degrees(h));
--TEST: should use index i_t1_a2j
select /*+ RECOMPILE */* from t1 where degrees(h)>=1; ;
--TEST Create successfully 
create index i_t1_a2i on t1(degrees(i));
--TEST: should use index i_t1_a2i
select /*+ RECOMPILE */* from t1 where degrees(i)<=9223372036854775807 ;
--TEST Create successfully 
create index i_t1_a2h on t1(degrees(j));
--TEST: should use index i_t1_a2h
select /*+ RECOMPILE */* from t1 where degrees(j)=0 ;
--TEST Create successfully 
create index i_t1_a2g on t1(degrees(k));
--TEST: should use index i_t1_a2g
select /*+ RECOMPILE */* from t1 where degrees(k)>k ;
--TEST Create successfully 
create index i_t1_a2f on t1(degrees(l));
--TEST: should not use index i_t1_a2f
select /*+ RECOMPILE */* from t1 where degrees(l)<l ;
--TEST: should not use index i_t1_a2f
select /*+ RECOMPILE */* from t1 where degrees(l)=0 ;
--TEST Create successfully 
create index i_t1_a2e on t1(degrees(m));
--TEST: should use index i_t1_a2e
select /*+ RECOMPILE */* from t1 where degrees(m)is not null ;
--TEST Create failed 
create index i_t1_a2d on t1(degrees(n));
--TEST Create failed 
create index i_t1_a2c on t1(degrees(o));
--TEST Create failed 
create index i_t1_a2b on t1(degrees(p));
--TEST Create failed 
create index i_t1_a2a on t1(degrees(q));
--TEST Create failed 
create index i_t1_a2a1 on t1(degrees(pi()/3));
--TEST Create failed 
create index i_t1_a2a2 on t1(degrees(h/3));

drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
