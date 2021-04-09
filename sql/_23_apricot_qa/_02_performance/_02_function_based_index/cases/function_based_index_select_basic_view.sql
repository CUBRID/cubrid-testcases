--+ holdcas on;
create table t1(  a varchar(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

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

create index i_t1_a2b on t1(lower(a));
--test
create index i_t1_a2b1 on t1(a,b) where a>'0';


--TEST: should use i_t1_a2b
create view v_t1_a2b as select /*+ RECOMPILE */ count(b) as num1,10 as num2 from t1 where exists (select t1.a)  and lower(a) > '0' ;
select /*+ RECOMPILE */ * from v_t1_a2b ;
alter view v_t1_a2b add query  select /*+ RECOMPILE */ count(b) as num1,10 as num2 from t1 where exists (select t1.a)  and lower(a) > '0' ;
select /*+ RECOMPILE */ * from v_t1_a2b ;

alter view v_t1_a2b add query  select /*+ RECOMPILE */ count(b) as num1,10 as num2 from t1 where exists (select t1.a from t1 where lower(a) > '0') ;
select /*+ RECOMPILE */ * from v_t1_a2b ;


alter view v_t1_a2b add query  select /*+ RECOMPILE */ count(b) as num1,10 as num2 from t1 where exists (select t1.a from t1 where lower(a) > '0')and a>'0' ;
select /*+ RECOMPILE */ * from v_t1_a2b ;

alter view v_t1_a2b add query  select /*+ RECOMPILE */ count(b) as num1,10 as num2 from t1 where exists (select t1.a from t1 where lower(a) > '0')and lower(a)>'0' ;
select /*+ RECOMPILE */ * from v_t1_a2b ;

alter view v_t1_a2b add query  select /*+ RECOMPILE */ count(b) as num1,10 as num2 from t1 where exists (select t1.a ) and a>'0' and lower(a) > '0' ;
select /*+ RECOMPILE */ * from v_t1_a2b ;


alter view v_t1_a2b add query  select /*+ RECOMPILE */ count(b) as num1,10 as num2 from t1 where exists (select t1.a )  and lower(a) > '0' and a>'0' ;
select /*+ RECOMPILE */ * from v_t1_a2b ;


alter view v_t1_a2b add query  select /*+ RECOMPILE */ count(b) as num1,10 as num2 from t1 where lower(a) > '0' or a>'0' ;
select /*+ RECOMPILE */ * from v_t1_a2b ;



drop view v_t1_a2b;
drop table t1;

commit;
--+ holdcas off;
