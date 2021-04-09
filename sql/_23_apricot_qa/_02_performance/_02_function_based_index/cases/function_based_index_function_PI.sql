--+ holdcas on;
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '1234567890',
  '1234567890',
  N'abc',
  N'ABC',
  B'1111111111',
  B'1111111111',
  2,
  8,
  9223372036854775807,
  1,
  0,
  1.1,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create failed 
create index i_t1_a2q on t1(PI());
--TEST Create failed 
create index i_t1_a2p on t1(PI()+b);
--TEST Create failed 
create index i_t1_a2o on t1(PI(c));
--TEST Create failed 
create index i_t1_a2n on t1(PI()*g);
--TEST Create failed 
create index i_t1_a2m on t1(PI()/2);
drop table t1;
commit;
--+ holdcas off;
