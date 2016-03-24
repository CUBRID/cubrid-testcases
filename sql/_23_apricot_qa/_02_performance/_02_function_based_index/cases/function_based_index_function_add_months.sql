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
  1.5678,
  -12.5678,
  -24,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(add_months(a,0));
--TEST Create failed 
create index i_t1_a2p on t1(add_months(b,0));
--TEST Create failed 
create index i_t1_a2o on t1(add_months(c,0));
--TEST Create failed 
create index i_t1_a2n on t1(add_months(d,0));
--TEST Create failed 
create index i_t1_a2m on t1(add_months(e,0));
--TEST Create failed 
create index i_t1_a2l on t1(add_months(f,0));
--TEST Create failed 
create index i_t1_a2k on t1(add_months(g,0));
--TEST Create failed 
create index i_t1_a2j on t1(add_months(h,-1));
--TEST Create failed 
create index i_t1_a2i on t1(add_months(i,0));
--TEST Create failed 
create index i_t1_a2h on t1(add_months(j,0));
--TEST Create failed 
create index i_t1_a2g on t1(add_months(k,3));
--TEST Create failed 
create index i_t1_a2f on t1(add_months(l,g));
--TEST Create failed 
create index i_t1_a2e on t1(add_months(m,0));
--TEST Create failed 
create index i_t1_a2d on t1(add_months(n,h));
--TEST Create failed 
create index i_t1_a2d1 on t1(add_months(n,1.1));
--TEST Create successfully  
create index i_t1_a2d on t1(add_months(n,g));
--TEST: should use index i_t1_a2d
select /*+ RECOMPILE */* from t1 where add_months(n,g)=DATE '2009-08-31' ;
--TEST Create failed  
create index i_t1_a2c on t1(add_months(o, 1));
--TEST Create failed  
create index i_t1_a2b on t1(add_months(p,g));
--TEST Create failed 
create index i_t1_a2b on t1(add_months(CAST(p AS DATE),g));
--TEST Create failed  
create index i_t1_a2a on t1(add_months(q,g));
--TEST Create failed  
create index i_t1_a2a on t1(add_months(CAST(q AS DATE),g));
drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
