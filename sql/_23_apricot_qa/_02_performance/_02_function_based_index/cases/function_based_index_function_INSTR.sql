--+ holdcas on;
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

INSERT into t1 values (
  '1234567890',
  '1234567890',
  N'ÀÈÌÀÈÌ',
  N'ÀÈÌ',
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
INSERT into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create successfully 
create index i_t1_a2q on t1(INSTR(a,'1',1)) ;
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where INSTR(a,'1',1)=0 ;
--TEST Create successfully 
create index i_t1_a2p on t1(INSTR(a,b,1));
--TEST: should use index i_t1_a2p
select /*+ RECOMPILE */* from t1 where INSTR(a,b,g)>=0 ;
--TEST Create successfully 
create index i_t1_a2o on t1(INSTR(c,d));
--TEST: should use index i_t1_a2o
select /*+ RECOMPILE */* from t1 where INSTR(c,d)<=2 ;
--TEST Create failed 
create index i_t1_a2n on t1(INSTR(a,n,h));
--TEST Create failed
create index i_t1_a2m on t1(INSTR(a,b,c));
--TEST Create failed
create index i_t1_a2l on t1(INSTR(a,g,h));
--TEST Create failed
create index i_t1_a2k on t1(INSTR(i,p));
--TEST Create failed
create index i_t1_a2j on t1(INSTR(p,1,d));
--TEST Create failed
create index i_t1_a2i on t1(INSTR(g,k,i));

drop table t1;
commit;
--+ holdcas off;
