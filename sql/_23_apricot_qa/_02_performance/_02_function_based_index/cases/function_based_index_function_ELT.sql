--+ holdcas on;
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
create index i_t1_a2q on t1(ELT(1,a,b,c));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where ELT(1,a,b,c)='1234567890' ;
--TEST Create successfully 
create index i_t1_a2p on t1(ELT(-1,a,b,c));
--TEST: should use index i_t1_a2p
select /*+ RECOMPILE */* from t1 where ELT(-1,a,b,c)>='123456789' ;
--TEST Create successfully 
create index i_t1_a2o on t1(ELT(2,c,d));
--TEST: should use index i_t1_a2o
select /*+ RECOMPILE */* from t1 where ELT(2.3,c,d)>=3 ;
--TEST Create failed 
create index i_t1_a2n on t1(ELT(2,p,q));
--TEST Create failed
create index i_t1_a2m on t1(ELT(1,e));
--TEST Create failed
create index i_t1_a2l on t1(ELT(1,f));
--TEST Create failed
create index i_t1_a2k on t1(ELT(1,a,g));
--TEST Create failed
create index i_t1_a2j on t1(ELT(3,h,q,p));
--TEST Create failed
create index i_t1_a2i on t1(ELT(1,i));
--TEST Create failed
create index i_t1_a2h on t1(ELT(1,j));
--TEST Create failed
create index i_t1_a2g on t1(ELT(1,k));
--TEST Create failed
create index i_t1_a2f on t1(ELT(1,l));
--TEST Create failed
create index i_t1_a2e on t1(ELT(1,m));
--TEST Create failed 
create index i_t1_a2d on t1(ELT(1,n));
--TEST Create failed 
create index i_t1_a2c on t1(ELT(1,o));
--TEST Create failed 
create index i_t1_a2b on t1(ELT(1.1,p));
--TEST Create failed 
create index i_t1_a2a on t1(ELT(0,q));
--TEST Create successfully 
create index i_t1_a2n on t1(ELT(h,'a','b'));
select /*+ RECOMPILE */* from t1 where ELT(h,'a','b')>='0';
drop table t1;
commit;
--+ holdcas off;
