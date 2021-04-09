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

--TEST Create failed
create index i_t1_a2q on t1(STRCMP (a,b));
--TEST Create successfully 
create index i_t1_a2q1 on t1(STRCMP (a,'abc'));
--TEST: should use index i_t1_a2q1
select /*+ RECOMPILE */* from t1 where STRCMP (a,'abc') =0 ;
create index i_t1_a2q2 on t1(STRCMP ('abc',a));
--TEST: should use index i_t1_a2q2
select /*+ RECOMPILE */* from t1 where STRCMP ('abc',a) >0 ;
--TEST Create successfully 
create index i_t1_a2p on t1(STRCMP (b,'12345678901'));
--TEST: should use index i_t1_a2p
select /*+ RECOMPILE */* from t1 where STRCMP (b,'12345678901') <0 ;
--TEST Create failed
create index i_t1_a2o on t1(STRCMP (c,null));
--TEST Create failed
create index i_t1_a2n on t1(STRCMP (d,c));
create index i_t1_a2n on t1(STRCMP (d,N'ABC'));
--TEST: should use index i_t1_a2n
select /*+ RECOMPILE */* from t1 where STRCMP (d,N'ABC') =0 ;
--TEST Create failed
create index i_t1_a2m on t1(STRCMP (e,null));
--TEST Create failed
create index i_t1_a2l on t1(STRCMP (f,'1'));
--TEST Create failed
create index i_t1_a2k on t1(STRCMP (g,'1'));
--TEST Create failed
create index i_t1_a2j on t1(STRCMP (h,'1'));
--TEST Create failed
create index i_t1_a2i on t1(STRCMP (i,'1'));
--TEST Create failed
create index i_t1_a2h on t1(STRCMP (j,'1'));
--TEST Create failed
create index i_t1_a2g on t1(STRCMP (k,'1'));
--TEST Create failed
create index i_t1_a2f on t1(STRCMP (l,'1'));
--TEST Create failed
create index i_t1_a2e on t1(STRCMP (m,'1'));
--TEST Create failed 
create index i_t1_a2d on t1(STRCMP (n,'1'));
--TEST Create failed 
create index i_t1_a2c on t1(STRCMP (o,'1'));
--TEST Create failed 
create index i_t1_a2b on t1(STRCMP (p,'1'));
--TEST Create failed 
create index i_t1_a2a on t1(STRCMP (q,'1'));

drop table t1;
commit;
--+ holdcas off;
