--+ holdcas on;
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '12/25/2008',
  '25/12/2008',
  N'081225',
  N'12/25/2008',
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
create index i_t1_a2q on t1(TO_DATE(a));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where TO_DATE(a)=DATE'12/25/2008' ;
--TEST Create successfully 
create index i_t1_a2p on t1(TO_DATE(b,'DD/MM/YYYY'));
--TEST: should use index i_t1_a2p
select /*+ RECOMPILE */* from t1 where TO_DATE(b,'DD/MM/YYYY')>=DATE'12/25/2008' ;
--TEST Create successfully 
create index i_t1_a2o on t1(TO_DATE(c,'YYMMDD', 'en_US'));
--TEST: should use index i_t1_a2o
select /*+ RECOMPILE */* from t1 where TO_DATE(c,'YYMMDD', 'en_US')=DATE'12/25/2008' ;
--TEST Create successfully 
create index i_t1_a2n on t1(TO_DATE(d,'YYYY-MM-DD', 'en_US'));
--TEST: should use index i_t1_a2n
select /*+ RECOMPILE */* from t1 where TO_DATE(d,'YYYY-MM-DD', 'en_US')=DATE'12/25/2008' ;
--TEST Create failed
create index i_t1_a2m on t1(TO_DATE(e,'YYMMDD'));
--TEST Create failed
create index i_t1_a2l on t1(TO_DATE(f,'DD/MM/YYYY'));
--TEST Create failed
create index i_t1_a2k on t1(TO_DATE(a,'YYMMDD'));
--TEST Create failed
create index i_t1_a2j on t1(TO_DATE(h,'YYMMDD','en_US'));
--TEST Create failed
create index i_t1_a2i on t1(TO_DATE(i,'YYMMDD'));
--TEST Create failed
create index i_t1_a2h on t1(TO_DATE(j,'YYMMDD'));
--TEST Create failed
create index i_t1_a2g on t1(TO_DATE(k,'YYYY-MM-DD'));
--TEST Create failed
create index i_t1_a2f on t1(TO_DATE(l,'YYMMDD'));
--TEST Create failed
create index i_t1_a2e on t1(TO_DATE(m,'YYMMDD'));
--TEST Create failed 
create index i_t1_a2d on t1(TO_DATE(n,'YYMMDD'));
--TEST Create failed 
create index i_t1_a2c on t1(TO_DATE(o,'YYMMDD'));
--TEST Create failed 
create index i_t1_a2b on t1(TO_DATE(p,'YYMMDD'));
--TEST Create failed 
create index i_t1_a2a on t1(TO_DATE(q,'YYMMDD'));

drop table t1;
commit;
--+ holdcas off;
