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
  82800,
  0,
  86399,
  0,
  82800.2,
  0,
  -1000000,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(SEC_TO_TIME(a));
--TEST Create failed 
create index i_t1_a2p on t1(SEC_TO_TIME(b));
--TEST Create failed 
create index i_t1_a2o on t1(SEC_TO_TIME(c));
--TEST Create failed 
create index i_t1_a2n on t1(SEC_TO_TIME(d));
--TEST Create failed 
create index i_t1_a2m on t1(SEC_TO_TIME(e));
--TEST Create failed 
create index i_t1_a2l on t1(SEC_TO_TIME(f));
--TEST Create successfully 
create index i_t1_a2k on t1(SEC_TO_TIME(g));
--TEST: should use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where SEC_TO_TIME(g) <=time'11:00:00 PM' using index i_t1_a2k(+);
--TEST Create successfully 
create index i_t1_a2j on t1(SEC_TO_TIME(h));
--TEST: should use index i_t1_a2j
select /*+ RECOMPILE */* from t1 where SEC_TO_TIME(h)<=time'00:00:00 AM' using index i_t1_a2j(+);
--TEST Create successfully 
create index i_t1_a2i on t1(SEC_TO_TIME(i));
--TEST: should use index i_t1_a2i
select /*+ RECOMPILE */* from t1 where SEC_TO_TIME(i)=time'11:59:59 PM' using index i_t1_a2i(+);
--TEST Create successfully 
create index i_t1_a2h on t1(SEC_TO_TIME(j));
--TEST: should use index i_t1_a2h
select /*+ RECOMPILE */* from t1 where SEC_TO_TIME(j)<=time'00:00:00 AM' using index i_t1_a2h(+);
--TEST Create successfully 
create index i_t1_a2g on t1(SEC_TO_TIME(k));
--TEST: should use index i_t1_a2g
select /*+ RECOMPILE */* from t1 where SEC_TO_TIME(k)<=time'11:00:00 PM' using index i_t1_a2g(+);
--TEST Create successfully 
create index i_t1_a2f on t1(SEC_TO_TIME(l));
--TEST: should use index i_t1_a2f
select /*+ RECOMPILE */* from t1 where SEC_TO_TIME(l)>=time'00:00:00 AM' using index i_t1_a2f(+);
--TEST Create successfully 
create index i_t1_a2e on t1(SEC_TO_TIME(m));
--TEST: should use index i_t1_a2e
select /*+ RECOMPILE */* from t1 where SEC_TO_TIME(m)is null using index i_t1_a2e(+);
--TEST Create failed 
create index i_t1_a2d on t1(SEC_TO_TIME(n));
--TEST Create failed 
create index i_t1_a2c on t1(SEC_TO_TIME(o));
--TEST Create failed 
create index i_t1_a2b on t1(SEC_TO_TIME(p));
--TEST Create failed 
create index i_t1_a2a on t1(SEC_TO_TIME(q));


drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
