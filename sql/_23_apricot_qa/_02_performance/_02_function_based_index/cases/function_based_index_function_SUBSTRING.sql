--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '1234567890',
  '12345678',
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
  TIME '13:15:45',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create successfully 
create index i_t1_a2q on t1(SUBSTRING  (a,2,1));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where SUBSTRING  (a,b)='2' ;
--TEST Create successfully 
create index i_t1_a2p on t1(SUBSTRING  (p,g,h));
--TEST: should use index i_t1_a2p
select /*+ RECOMPILE */* from t1 where SUBSTRING  (p,g,h)>=' 01:15:45' ;
--TEST Create successfully 
create index i_t1_a2o on t1(SUBSTRING  (c,i,j));
--TEST: should use index i_t1_a2o
select /*+ RECOMPILE */* from t1 where SUBSTRING  (c,i,j)>='' ;
--TEST Create successfully 
create index i_t1_a2n on t1(SUBSTRING  (d,k,l));
--TEST: should use index i_t1_a2n
select /*+ RECOMPILE */* from t1 where SUBSTRING  (d,k,l)<'' ;
--TEST Create failed
create index i_t1_a2m on t1(SUBSTRING  (e,f,g));
--TEST Create failed
create index i_t1_a2l on t1(SUBSTRING  (j,g,k));
--TEST Create failed
create index i_t1_a2k on t1(SUBSTRING  (a,b,1));
--TEST Create failed
create index i_t1_a2j on t1(SUBSTRING  (o,p,1));

drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
