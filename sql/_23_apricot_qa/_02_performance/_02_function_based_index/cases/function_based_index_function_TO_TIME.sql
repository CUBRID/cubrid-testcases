--+ holdcas on;
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '13:10:30',
  'HOUR: 13 MINUTE: 10 SECOND: 30',
  N'13:10:30',
  N'13:10:30',
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
create index i_t1_a2q on t1(TO_TIME(a));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where TO_TIME(a)=TIME'01:10:30 PM' ;
--TEST Create successfully 
create index i_t1_a2p on t1(TO_TIME(b,'"HOUR:" HH24 "MINUTE:" MI "SECOND:" SS', 'en_US'));
--TEST: should use index i_t1_a2p
select /*+ RECOMPILE */* from t1 where TO_TIME(b,'"HOUR:" HH24 "MINUTE:" MI "SECOND:" SS', 'en_US')>=TIME'01:10:30 PM' ;
--TEST Create successfully 
create index i_t1_a2o on t1(TO_TIME(c,'HH24:MI:SS', 'en_US'));
--TEST: should use index i_t1_a2o
select /*+ RECOMPILE */* from t1 where TO_TIME(c,'HH24:MI:SS', 'en_US')=TIME'01:10:30 PM' ;
--TEST Create successfully 
create index i_t1_a2n on t1(TO_TIME(d,'HH12:MI:SS'));
--TEST: should use index i_t1_a2n
select /*+ RECOMPILE */* from t1 where TO_TIME(d,'HH12:MI:SS')is null ;
--TEST Create failed
create index i_t1_a2m on t1(TO_TIME(e,'HH24:MI:SS'));
--TEST Create failed
create index i_t1_a2l on t1(TO_TIME(f));
--TEST Create failed
create index i_t1_a2k on t1(TO_TIME(a,'HH24:MI:SS'));
--TEST Create failed
create index i_t1_a2j on t1(TO_TIME(h,'HH24:MI:SS','en_US'));
--TEST Create failed
create index i_t1_a2i on t1(TO_TIME(i,'HH24:MI:SS'));
--TEST Create failed
create index i_t1_a2h on t1(TO_TIME(j,'HH24:MI:SS'));
--TEST Create failed
create index i_t1_a2g on t1(TO_TIME(k));
--TEST Create failed
create index i_t1_a2f on t1(TO_TIME(l,'HH24:MI:SS'));
--TEST Create failed
create index i_t1_a2e on t1(TO_TIME(m,'HH24:MI:SS'));
--TEST Create failed 
create index i_t1_a2d on t1(TO_TIME(n,'HH24:MI:SS'));
--TEST Create failed 
create index i_t1_a2c on t1(TO_TIME(o,'HH24:MI:SS'));
--TEST Create failed 
create index i_t1_a2b on t1(TO_TIME(p,'HH24:MI:SS'));
--TEST Create failed 
create index i_t1_a2a on t1(TO_TIME(q,'HH24:MI:SS'));

drop table t1;
commit;
--+ holdcas off;
