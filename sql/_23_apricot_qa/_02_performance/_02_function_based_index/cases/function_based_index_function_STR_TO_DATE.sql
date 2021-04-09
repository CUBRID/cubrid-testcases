--+ holdcas on;
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '01,5,2013',
  'May 1, 2013',
  N'a09:30:17',
  N'a09:30:17',
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

--TEST Create successfully 
create index i_t1_a2q on t1(str_to_date(a, '%d,%m,%Y'));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where str_to_date(a, '%d,%m,%Y') <=DATE '05/01/2013' ;
--TEST Create successfully 
create index i_t1_a2p on t1(str_to_date(b, '%M %d,%Y'));
--TEST: should use index i_t1_a2p
select /*+ RECOMPILE */* from t1 where str_to_date(b, '%M %d,%Y') =DATE '05/01/2013' ;
--TEST Create successfully 
create index i_t1_a2o on t1(str_to_date(c, 'a%h:%i:%s'));
--TEST: should use index i_t1_a2o
select /*+ RECOMPILE */* from t1 where str_to_date(c, 'a%h:%i:%s') =time '09:30:17 AM' ;
--TEST Create successfully 
create index i_t1_a2n on t1(STR_TO_DATE(d, 'a%h:%i:%s'));
--TEST: should use index i_t1_a2n
select /*+ RECOMPILE */* from t1 where str_to_date(d, 'a%h:%i:%s') =time '09:30:17 AM' ;
--TEST Create failed 
create index i_t1_a2m on t1(STR_TO_DATE(e, 'a%h:%i:%s'));
--TEST Create failed 
create index i_t1_a2l on t1(STR_TO_DATE(f, 'a%h:%i:%s'));
--TEST Create failed 
create index i_t1_a2k on t1(STR_TO_DATE(g, 'a%h:%i:%s'));
--TEST Create failed 
create index i_t1_a2j on t1(STR_TO_DATE(h, 'a%h:%i:%s'));
--TEST Create failed 
create index i_t1_a2i on t1(STR_TO_DATE(i, 'a%h:%i:%s'));
--TEST Create failed 
create index i_t1_a2h on t1(STR_TO_DATE(j, 'a%h:%i:%s'));
--TEST Create failed 
create index i_t1_a2g on t1(STR_TO_DATE(k, 'a%h:%i:%s'));
--TEST Create failed 
create index i_t1_a2f on t1(STR_TO_DATE(l, 'a%h:%i:%s'));
--TEST Create failed 
create index i_t1_a2e on t1(STR_TO_DATE(m, 'a%h:%i:%s'));
--TEST Create failed 
create index i_t1_a2d on t1(STR_TO_DATE(n, 'a%h:%i:%s'));
--TEST Create failed 
create index i_t1_a2c on t1(STR_TO_DATE(o, 'a%h:%i:%s'));
--TEST Create failed 
create index i_t1_a2b on t1(STR_TO_DATE(p, 'a%h:%i:%s'));
--TEST Create failed 
create index i_t1_a2a on t1(STR_TO_DATE(q, 'a%h:%i:%s'));


drop table t1;
commit;
--+ holdcas off;
