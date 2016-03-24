--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
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
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(EXTRACT(millisecond  from a));
--TEST Create failed 
create index i_t1_a2p on t1(EXTRACT(millisecond  from b));
--TEST Create failed 
create index i_t1_a2o on t1(EXTRACT(millisecond  from c));
--TEST Create failed 
create index i_t1_a2n on t1(EXTRACT(millisecond  from d));
--TEST Create failed 
create index i_t1_a2m on t1(EXTRACT(millisecond  from e));
--TEST Create failed 
create index i_t1_a2l on t1(EXTRACT(millisecond  from f));
--TEST Create failed 
create index i_t1_a2k on t1(EXTRACT(millisecond  from g));
--TEST Create failed 
create index i_t1_a2j on t1(EXTRACT(millisecond  from h));
--TEST Create failed 
create index i_t1_a2i on t1(EXTRACT(millisecond  from i));
--TEST Create failed 
create index i_t1_a2h on t1(EXTRACT(millisecond  from j));
--TEST Create failed 
create index i_t1_a2g on t1(EXTRACT(millisecond  from k));
--TEST Create failed 
create index i_t1_a2f on t1(EXTRACT(millisecond  from l));
--TEST Create failed 
create index i_t1_a2e on t1(EXTRACT(millisecond  from m));
--TEST Create failed 
create index i_t1_a2d on t1(EXTRACT(month  from n));
--TEST: should use index i_t1_a2d
--select /*+ RECOMPILE */* from t1 where EXTRACT(month  from n)=10 using index i_t1_a2d(+);
--TEST Create failed 
create index i_t1_a2c on t1(EXTRACT(hour  from o));
--TEST Create failed  
create index i_t1_a2c1 on t1(EXTRACT(day from o));
--TEST: should use index i_t1_a2c
--select /*+ RECOMPILE */* from t1 where EXTRACT(hour  from o)=0 using index i_t1_a2c(+);
--TEST Create failed 
create index i_t1_a2b on t1(EXTRACT(year  from p));
--TEST: should use index i_t1_a2b
--select /*+ RECOMPILE */* from t1 where EXTRACT(year  from pp)>=2010 using index i_t1_a2b(+);
--TEST Create failed  
create index i_t1_a2a on t1(EXTRACT(DAY from q));
--TEST: should use index i_t1_a2a
--select /*+ RECOMPILE */* from t1 where EXTRACT(DAY from q)) <=31 using index i_t1_a2a(+);
drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
