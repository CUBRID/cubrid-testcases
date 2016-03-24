--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '13:10:30 12/25/2008',
  '08-Dec-25 13:10:30',
  N'YEAR: 2008 DATE: 12-25 TIME: 13:10:30',
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
create index i_t1_a2q on t1(TO_TIMESTAMP(a));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where TO_TIMESTAMP(a)=TIMESTAMP'01:10:30 PM 12/25/2008' ;
--TEST Create successfully 
create index i_t1_a2p on t1(TO_TIMESTAMP(b,'YY-Mon-DD HH24:MI:SS', 'en_US'));
--TEST: should use index i_t1_a2p
select /*+ RECOMPILE */* from t1 where TO_TIMESTAMP(b,'YY-Mon-DD HH24:MI:SS', 'en_US')>=TIMESTAMP'01:10:30 PM 12/25/2008' ;
--TEST Create successfully 
create index i_t1_a2o on t1(TO_TIMESTAMP(c, '"YEAR:" YYYY "DATE:" MM-DD "TIME:" HH24:MI:SS', 'en_US'));
--TEST: should use index i_t1_a2o
select /*+ RECOMPILE */* from t1 where TO_TIMESTAMP(c, '"YEAR:" YYYY "DATE:" MM-DD "TIME:" HH24:MI:SS', 'en_US')=TIMESTAMP'01:10:30 PM 12/25/2008' ;
--TEST Create successfully 
create index i_t1_a2n on t1(TO_TIMESTAMP(d));
--TEST: should use index i_t1_a2n
select /*+ RECOMPILE */* from t1 where TO_TIMESTAMP(d)is null ;
--TEST Create failed
create index i_t1_a2m on t1(TO_TIMESTAMP(e,'YY-Mon-DD HH24:MI:SS'));
--TEST Create failed
create index i_t1_a2l on t1(TO_TIMESTAMP(f));
--TEST Create failed
create index i_t1_a2k on t1(TO_TIMESTAMP(a,'YY-Mon-DD HH24:MI:SS'));
--TEST Create failed
create index i_t1_a2j on t1(TO_TIMESTAMP(h,'YY-Mon-DD HH24:MI:SS','en_US'));
--TEST Create failed
create index i_t1_a2i on t1(TO_TIMESTAMP(i,'YY-Mon-DD HH24:MI:SS'));
--TEST Create failed
create index i_t1_a2h on t1(TO_TIMESTAMP(j,'YY-Mon-DD HH24:MI:SS'));
--TEST Create failed
create index i_t1_a2g on t1(TO_TIMESTAMP(k));
--TEST Create failed
create index i_t1_a2f on t1(TO_TIMESTAMP(l,'YY-Mon-DD HH24:MI:SS'));
--TEST Create failed
create index i_t1_a2e on t1(TO_TIMESTAMP(m,'YY-Mon-DD HH24:MI:SS'));
--TEST Create failed 
create index i_t1_a2d on t1(TO_TIMESTAMP(n,'YY-Mon-DD HH24:MI:SS'));
--TEST Create failed 
create index i_t1_a2c on t1(TO_TIMESTAMP(o,'YY-Mon-DD HH24:MI:SS'));
--TEST Create failed 
create index i_t1_a2b on t1(TO_TIMESTAMP(p,'YY-Mon-DD HH24:MI:SS'));
--TEST Create failed 
create index i_t1_a2a on t1(TO_TIMESTAMP(q,'YY-Mon-DD HH24:MI:SS'));

drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
