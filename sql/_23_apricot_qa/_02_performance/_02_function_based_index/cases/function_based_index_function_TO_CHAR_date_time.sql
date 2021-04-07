--+ holdcas on;
create table t1(a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '2009-10-04',
  '2009-10-04 22:23:00',
  N'2009-10-04 22:23:00',
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
  TIMESTAMP '2010-02-04 16:50:11',
  DATETIME  '2010-02-04 16:50:11');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(to_char(a, 'DD, DY , MON, YYYY'));
--TEST Create failed 
create index i_t1_a2p on t1(to_char(b, 'Day Month yyyy'));
--TEST Create failed 
create index i_t1_a2o on t1(to_char(c,'HH12:MI:SS:FF pm, YYYY-MM-DD-DAY'));
--TEST Create failed 
create index i_t1_a2n on t1(to_char(d, 'HH12:MI:SS:FF pm, YYYY-MM-DD-DAY'));
--TEST Create failed 
create index i_t1_a2m on t1(to_char(e,'HH12:MI:SS:FF pm, YYYY-MM-DD-DAY'));
--TEST Create failed 
create index i_t1_a2l on t1(to_char(f,'HH12:MI:SS:FF pm, YYYY-MM-DD-DAY'));
--TEST Create failed 
create index i_t1_a2k on t1(to_char(g,'HH12:MI:SS:FF pm, YYYY-MM-DD-DAY'));
--TEST Create failed 
create index i_t1_a2j on t1(to_char(h,'HH12:MI:SS:FF pm, YYYY-MM-DD-DAY'));
--TEST Create failed 
create index i_t1_a2i on t1(to_char(i,'HH12:MI:SS:FF pm, YYYY-MM-DD-DAY'));
--TEST Create failed 
create index i_t1_a2h on t1(to_char(j,'HH12:MI:SS:FF pm, YYYY-MM-DD-DAY'));
--TEST Create failed 
create index i_t1_a2g on t1(to_char(k,'HH12:MI:SS:FF pm, YYYY-MM-DD-DAY'));
--TEST Create failed 
create index i_t1_a2f on t1(to_char(l,'HH12:MI:SS:FF pm, YYYY-MM-DD-DAY'));
--TEST Create failed 
create index i_t1_a2e on t1(to_char(m,'HH12:MI:SS:FF pm, YYYY-MM-DD-DAY'));
--TEST Create failed  
create index i_t1_a2d on t1(to_char(n,'HH12:MI:SS:FF pm, YYYY-MM-DD-DAY'));
--TEST Create successfully  
create index i_t1_a2d on t1(to_char(n,'DD, DY , MON, YYYY'));
--TEST: should use index i_t1_a2d
select /*+ RECOMPILE */* from t1 where to_char(n,'DD, DY , MON, YYYY')>='04, WED , OCT, 2009' ;
--TEST Create failed 
create index i_t1_a2c on t1(to_char(o,'DD, DY , MON, YYYY'));
--TEST Create failed  
create index i_t1_a2b on t1(to_char(p,'HH12:MI:SS:FF pm, YYYY-MM-DD-DAY')) using index i_t1_a2c(+);
--TEST Create successfully  
create index i_t1_a2b on t1(to_char(p,'HH24:MI, DD, MONTH, YYYY'));
--TEST: should use index i_t1_a2b
select /*+ RECOMPILE */* from t1 where to_char(p,'HH24:MI, DD, MONTH, YYYY')='16:50, 04, FEBRUARY , 2010' ;
--TEST Create successfully  
create index i_t1_a2a on t1(to_char(q,'HH24:MI, DD, MONTH, YYYY'));
--TEST: should use index i_t1_a2a
select /*+ RECOMPILE */* from t1 where to_char(q,'HH24:MI, DD, MONTH, YYYY')) <='04:50:11:000 pm, 2010-02-04-THURSDAY ' ;
drop table t1;
commit;
--+ holdcas off;
