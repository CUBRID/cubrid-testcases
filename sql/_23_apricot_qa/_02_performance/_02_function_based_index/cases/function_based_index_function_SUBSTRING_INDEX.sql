--+ holdcas on;
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '1234567890',
  '234567890',
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
create index i_t1_a2q on t1(SUBSTRING_INDEX (a,b,1));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where SUBSTRING_INDEX (a,b,1) ='1' ;
--TEST Create successfully 
create index i_t1_a2p on t1(SUBSTRING_INDEX (b,'234567890',g));
--TEST: should use index i_t1_a2p
select /*+ RECOMPILE */* from t1 where SUBSTRING_INDEX (b,'234567890',g) ='234567890' ;
--TEST Create failed 
create index i_t1_a2o on t1(SUBSTRING_INDEX (c,null,g));

--TEST Create successfully 
create index i_t1_a2n on t1(SUBSTRING_INDEX (d,c,g));
--TEST: should use index i_t1_a2n
select /*+ RECOMPILE */* from t1 where SUBSTRING_INDEX (d,c,g)>N'0' ;
--TEST Create failed
create index i_t1_a2m on t1(SUBSTRING_INDEX (e,'1',0));
--TEST Create failed
create index i_t1_a2l on t1(SUBSTRING_INDEX (f,'1',0));
--TEST Create failed
create index i_t1_a2k on t1(SUBSTRING_INDEX (g,'1',0));
--TEST Create failed
create index i_t1_a2j on t1(SUBSTRING_INDEX (h,'1',0));
--TEST Create failed
create index i_t1_a2i on t1(SUBSTRING_INDEX (i,'1',0));
--TEST Create failed
create index i_t1_a2h on t1(SUBSTRING_INDEX (j,'1',0));
--TEST Create failed
create index i_t1_a2g on t1(SUBSTRING_INDEX (k,'1',0));
--TEST Create failed
create index i_t1_a2f on t1(SUBSTRING_INDEX (l,'1',0));
--TEST Create failed
create index i_t1_a2e on t1(SUBSTRING_INDEX (m,'1',0));
--TEST Create failed 
create index i_t1_a2d on t1(SUBSTRING_INDEX (n,'1',0));
--TEST Create failed 
create index i_t1_a2c on t1(SUBSTRING_INDEX (o,'1',0));
--TEST Create failed 
create index i_t1_a2b on t1(SUBSTRING_INDEX (p,'1',0));
--TEST Create failed 
create index i_t1_a2a on t1(SUBSTRING_INDEX (q,'1',0));

drop table t1;
commit;
--+ holdcas off;
