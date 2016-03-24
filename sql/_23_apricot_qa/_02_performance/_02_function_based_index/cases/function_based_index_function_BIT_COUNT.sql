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
create index i_t1_a2q on t1(bit_count(a));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where bit_count(a)=3 using index i_t1_a2q(+);
--TEST Create successfully 
create index i_t1_a2p on t1(bit_count(b));
--TEST: should use index i_t1_a2p
select /*+ RECOMPILE */* from t1 where bit_count(b)=3 using index i_t1_a2p(+);
--TEST Create successfully 
create index i_t1_a2o on t1(bit_count(c));
--TEST: should use index i_t1_a2o
select /*+ RECOMPILE */* from t1 where bit_count(c)=3 using index i_t1_a2o(+);
--TEST Create successfully 
create index i_t1_a2n on t1(bit_count(d));
--TEST: should use index i_t1_a2n
select /*+ RECOMPILE */* from t1 where bit_count(d)=3 using index i_t1_a2n(+);
--TEST Create successfully 
create index i_t1_a2m on t1(bit_count(e));
--TEST: should use index i_t1_a2m
select /*+ RECOMPILE */* from t1 where bit_count(e)>1 using index i_t1_a2m(+);
--TEST Create successfully 
create index i_t1_a2l on t1(bit_count(f));
--TEST: should use index i_t1_a2l
select /*+ RECOMPILE */* from t1 where bit_count(f)<2 using index i_t1_a2l(+);
--TEST Create successfully 
create index i_t1_a2k on t1(bit_count(g));
--TEST: should use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where bit_count(g)=0 using index i_t1_a2k(+);
--TEST Create successfully 
create index i_t1_a2j on t1(bit_count(h));
--TEST: should use index i_t1_a2j
select /*+ RECOMPILE */* from t1 where bit_count(h)<=0 using index i_t1_a2j(+);
--TEST Create successfully 
create index i_t1_a2i on t1(bit_count(i));
--TEST: should use index i_t1_a2i
select /*+ RECOMPILE */* from t1 where bit_count(i)>=0 using index i_t1_a2i(+);
--TEST Create successfully 
create index i_t1_a2h on t1(bit_count(j));
--TEST: should use index i_t1_a2h
select /*+ RECOMPILE */* from t1 where bit_count(j)<=-1 using index i_t1_a2h(+);
--TEST Create successfully 
create index i_t1_a2g on t1(bit_count(k));
--TEST: should use index i_t1_a2g
select /*+ RECOMPILE */* from t1 where bit_count(k)>=-1 using index i_t1_a2g(+);
--TEST Create successfully 
create index i_t1_a2f on t1(bit_count(l));
--TEST: should use index i_t1_a2f
select /*+ RECOMPILE */* from t1 where bit_count(l)=3 using index i_t1_a2f(+);
--TEST Create successfully 
create index i_t1_a2e on t1(bit_count(m));
--TEST: should use index i_t1_a2e
select /*+ RECOMPILE */* from t1 where bit_count(m)=3 using index i_t1_a2e(+);
--TEST Create successfully 
create index i_t1_a2d on t1(bit_count(n));
--TEST: should use index i_t1_a2d
select /*+ RECOMPILE */* from t1 where bit_count(n)=3 using index i_t1_a2d(+);
--TEST Create successfully 
create index i_t1_a2c on t1(bit_count(o));
--TEST: should use index i_t1_a2c
select /*+ RECOMPILE */* from t1 where bit_count(o)=3 using index i_t1_a2c(+);
--TEST Create successfully 
create index i_t1_a2b on t1(bit_count(p));
--TEST: should use index i_t1_a2b
select /*+ RECOMPILE */* from t1 where bit_count(p)=3 using index i_t1_a2b(+);
--TEST Create successfully 
create index i_t1_a2a on t1(bit_count(q));
--TEST: should use index i_t1_a2a
select /*+ RECOMPILE */* from t1 where bit_count(q)=3 using index i_t1_a2a(+);
--TEST Create successfully 


drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
