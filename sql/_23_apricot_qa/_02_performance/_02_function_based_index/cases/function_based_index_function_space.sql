--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
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

create index i_t1_a2q on t1(space(a));
create index i_t1_a2p on t1(space(b));
create index i_t1_a2o on t1(space(c));
create index i_t1_a2n on t1(space(d));
create index i_t1_a2m on t1(space(e));
create index i_t1_a2l on t1(space(f));
create index i_t1_a2k on t1(space(g));
select /*+ RECOMPILE */* from t1 where space(g) ='          ' ;
create index i_t1_a2j on t1(space(h));
create index i_t1_a2i on t1(space(i));
create index i_t1_a2h on t1(space(j));
create index i_t1_a2g on t1(space(k));
create index i_t1_a2f on t1(space(l));
create index i_t1_a2e on t1(space(m));
create index i_t1_a2d on t1(space(n));
create index i_t1_a2c on t1(space(o));
create index i_t1_a2b on t1(space(p));
create index i_t1_a2a on t1(space(q));

drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
