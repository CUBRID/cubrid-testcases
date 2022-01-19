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
insert into t1 values (null,null,null,null,null,null,0,null,null,null,null,null,null,null,null,null,null);
insert into t1 values (null,null,null,null,null,null,null,1,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(IF(a is null,'a',a));
--TEST Create failed 
create index i_t1_a2q on t1(IF(a = '','a',a));
--TEST Create failed 
create index i_t1_a2q on t1(IF(a<>0,a,'a'));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where IF(a<>0,a,'a')='a' ;
--TEST Create successfully 
create index i_t1_a2p on t1(IF(a<>0,b<>0,c<>0));
--TEST: should use both index i_t1_a2p and i_t1_a2q
select /*+ RECOMPILE */* from t1 where IF(a<>0,b<>0,c<>0)='b' ;
--TEST Create successfully 
create index i_t1_a2k on t1(IF(g<>0,h<>0,i<>0));
--TEST: should use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where IF(g<>0,h,i)=i ;

drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
