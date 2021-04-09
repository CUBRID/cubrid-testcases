--+ holdcas on;
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '-1234',
  '12345',
  N'$12,345.67',
  N'12345.67',
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
create index i_t1_a2q on t1(TO_NUMBER(a));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where TO_NUMBER(a)= -1234 ;
--TEST Create successfully 
create index i_t1_a2p on t1(TO_NUMBER(b,'999999'));
--TEST: should use index i_t1_a2p
select /*+ RECOMPILE */* from t1 where TO_NUMBER(b,'999999')>=12345 ;
--TEST Create successfully 
create index i_t1_a2o on t1(TO_NUMBER(c,'C99,999.999'));
--TEST: should use index i_t1_a2o
select /*+ RECOMPILE */* from t1 where TO_NUMBER(c,'C99,999.999')=12345.670 ;
--TEST Create successfully 
create index i_t1_a2n on t1(TO_NUMBER(d,'9999.999'));
--TEST: should use index i_t1_a2n
select /*+ RECOMPILE */* from t1 where TO_NUMBER(d,'9999.999')=12345.670 ;
--TEST Create failed
create index i_t1_a2m on t1(TO_NUMBER(e,'999999'));
--TEST Create failed
create index i_t1_a2l on t1(TO_NUMBER(f));
--TEST Create failed
create index i_t1_a2k on t1(TO_NUMBER(a,'999999'));
--TEST Create failed
create index i_t1_a2j on t1(TO_NUMBER(h,'999999'));
--TEST Create failed
create index i_t1_a2i on t1(TO_NUMBER(i,'999999'));
--TEST Create failed
create index i_t1_a2h on t1(TO_NUMBER(j,'999999'));
--TEST Create failed
create index i_t1_a2g on t1(TO_NUMBER(k));
--TEST Create failed
create index i_t1_a2f on t1(TO_NUMBER(l,'999999'));
--TEST Create failed
create index i_t1_a2e on t1(TO_NUMBER(m,'999999'));
--TEST Create failed 
create index i_t1_a2d on t1(TO_NUMBER(n,'C99,999.999'));
--TEST Create failed 
create index i_t1_a2c on t1(TO_NUMBER(o,'999999'));
--TEST Create failed 
create index i_t1_a2b on t1(TO_NUMBER(p,'999999'));
--TEST Create failed 
create index i_t1_a2a on t1(TO_NUMBER(q,'99999.999'));

drop table t1;
commit;
--+ holdcas off;
