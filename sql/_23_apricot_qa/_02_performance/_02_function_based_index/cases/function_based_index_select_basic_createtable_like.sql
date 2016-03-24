--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '1234567890',
  'SQL',
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

create index i_t1_a2a on t1(lower(b));

create table t2 like t1;
--TEST
insert into t2 select * from t1 where lower(b)>'0' ;
--TEST
select /*+ RECOMPILE */ count(*) from t2 where lower(b)>'0' ;
--TEST
select /*+ RECOMPILE */ a from t2 where lower(b)>'0' ;
--TEST
select /*+ RECOMPILE */ * from t2 where lower(b)>'0' ;

drop table t1;
drop table t2;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
