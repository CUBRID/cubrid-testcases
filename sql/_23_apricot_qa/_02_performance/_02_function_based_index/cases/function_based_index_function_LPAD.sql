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
create index i_t1_a2q on t1(LPAD (a,10,b));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where LPAD (a,10,b)='12345678901234567890' ;
--TEST Create successfully 
create index i_t1_a2p on t1(LPAD (c,g,d));
--TEST: should use index i_t1_a2p
select /*+ RECOMPILE */* from t1 where LPAD (c,g,d)>N'ABC    abc' ;
--TEST Create successfully 
create index i_t1_a2o on t1(LPAD (c,g,N'?'));
--TEST: should use index i_t1_a2o
select /*+ RECOMPILE */* from t1 where LPAD (c,g,N'?')>=N'abc' ;
--TEST Create failed 
create index i_t1_a2n on t1(LPAD (n,l,o));
--TEST Create failed
create index i_t1_a2m on t1(LPAD (e,h,a));
--TEST Create failed
create index i_t1_a2l on t1(LPAD (j,g,p));
--TEST Create failed
create index i_t1_a2k on t1(LPAD (n,o,p));
--TEST Create failed


drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
