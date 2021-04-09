--+ holdcas on;
create table t1(a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '22:23:00',
  '23:59:00',
  N'1900-10-04 22:23:00',
  N'1999-01-01',
  B'1111111111',
  B'1111111111',
  10,
  255,
  9223372036854775807,
  0,
  1.5678,
  -12.5678,
  -24,
  DATE '1999-01-01',
  TIME '22:23:00',
  TIMESTAMP '1900-10-04 22:23:00',
  DATETIME  '2009-10-04 22:23:00');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create successfully 
create index i_t1_a2q on t1(TIME_FORMAT(a, '%H %i %s'));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where TIME_FORMAT(a, '%H %i %s')='22 23 00' ;
--TEST Create successfully 
create index i_t1_a2p on t1(TIME_FORMAT(b, '%H %h %i %s %f'));
--TEST: should use index i_t1_a2p
select /*+ RECOMPILE */* from t1 where TIME_FORMAT(b, '%H %h %i %s %f')>='23 11 59 00 000' ;
--TEST Create successfully 
create index i_t1_a2o on t1(TIME_FORMAT(c,'%H %i %s'));
--TEST: should use index i_t1_a2o
select /*+ RECOMPILE */* from t1 where TIME_FORMAT(c,'%H %i %s')<='22 23 00' ;
--TEST Create successfully 
create index i_t1_a2n on t1(TIME_FORMAT(d, '%H %i %s'));
--TEST: should use index i_t1_a2n
select /*+ RECOMPILE */* from t1 where TIME_FORMAT(d, '%H %i %s')is null ;
--TEST Create failed 
create index i_t1_a2m on t1(TIME_FORMAT(e, '%H %i %s'));
--TEST Create failed 
create index i_t1_a2l on t1(TIME_FORMAT(f, '%H %i %s'));
--TEST Create failed 
create index i_t1_a2k on t1(TIME_FORMAT(g, '%H %i %s'));
--TEST Create failed 
create index i_t1_a2j on t1(TIME_FORMAT(h, '%H %i %s'));
--TEST Create failed 
create index i_t1_a2i on t1(TIME_FORMAT(i, '%H %i %s'));
--TEST Create failed 
create index i_t1_a2h on t1(TIME_FORMAT(j, '%H %i %s'));
--TEST Create failed 
create index i_t1_a2g on t1(TIME_FORMAT(k, '%H %i %s'));
--TEST Create failed 
create index i_t1_a2f on t1(TIME_FORMAT(l, '%H %i %s'));
--TEST Create failed 
create index i_t1_a2e on t1(TIME_FORMAT(m, '%H %i %s'));
--TEST Create failed  
create index i_t1_a2d on t1(TIME_FORMAT(n,'%H %i %s'));
--TEST Create successfully 
create index i_t1_a2c on t1(TIME_FORMAT(o,'%H:%i:%s'));
--TEST: should use index i_t1_a2c
select /*+ RECOMPILE */* from t1 where TIME_FORMAT(o,'%H:%i:%s')>= '22 23 00%' ;
--TEST Create successfully  
create index i_t1_a2b on t1(TIME_FORMAT(p,'%H:%i:%s'));
--TEST: should use index i_t1_a2b
select /*+ RECOMPILE */* from t1 where TIME_FORMAT(p,'%H:%i:%s')>='22 23 00' ;
--TEST Create successfully  
create index i_t1_a2a on t1(TIME_FORMAT(q,'%H:%i:%s'));
--TEST: should use index i_t1_a2a
select /*+ RECOMPILE */* from t1 where TIME_FORMAT(q,'%H:%i:%s') <='22 23 00' ;
drop table t1;
commit;
--+ holdcas off;
