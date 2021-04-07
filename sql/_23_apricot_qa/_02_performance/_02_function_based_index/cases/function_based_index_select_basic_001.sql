--+ holdcas on;
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
  1.5678,
  -12.5678,
  -24,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

CREATE INDEX i_t1_a ON t1(LOWER (b));
select /*+ RECOMPILE */* from t1 where LOWER(b) = 'sql' ;

CREATE INDEX i_t1_d ON t1(LOWER(d));
select /*+ RECOMPILE */* from t1 where LOWER(d) = N'abc' ;
select /*+ RECOMPILE */* from t1 where UPPER(LOWER(b)) = 'SQL' ;
select /*+ RECOMPILE */* from t1 where LOWER(d) = N'abc'and LENGTH(d)>=0 ;
select /*+ RECOMPILE */* from t1 where LOWER(d) = N'abc'and LENGTH(a)>=0 ;
select /*+ RECOMPILE */* from t1 where LOWER(b) = 'sql'and LENGTH(d)>=0 ;
select /*+ RECOMPILE */* from t1 where LOWER(b) = 'sql'and LOWER(d) = N'abc' ;
select /*+ RECOMPILE */* from t1 where LOWER(b) = 'sql' or 1=0;
select /*+ RECOMPILE */* from t1 where LOWER(b) = 'sql' or 1=1;
select /*+ RECOMPILE */* from t1 where LOWER(d) = N'abc' and LOWER(b) = 'sql' ;
select /*+ RECOMPILE */* from t1 where LOWER(d) = N'abc' and LOWER(b) = 'sql' using index i_t1_d;
select /*+ RECOMPILE */* from t1 where LOWER(d) = N'abc' or LOWER(b) = 'sql' ;
select /*+ RECOMPILE */* from t1 where LOWER(b) = 'sql' or LOWER(d) = N'abc' ;
CREATE INDEX i_t1_a1 ON t1(LOWER(a));
select /*+ RECOMPILE */* from t1 where LOWER(a) = LOWER(a) ;
CREATE INDEX i_t1_a3 ON t1(a) where a is not null;
select /*+ RECOMPILE */* from t1 where LOWER(a) = 'SQL' and a is not null ;
select /*+ RECOMPILE */* from t1 where a is not null and LOWER(b) = 'sql' ;
select /*+ RECOMPILE */* from t1 where LOWER(d) = N'abc' or 1=1 ;
select /*+ RECOMPILE */* from t1 where LOWER(d) = N'abc' and 1=0 ;
CREATE INDEX i_t1_a4 ON t1(b) where LOWER(b)='sql';
select /*+ RECOMPILE */* from t1 where LOWER(b) = 'sql';
select /*+ RECOMPILE */* from t1 where LOWER(b) = 'sql' using index i_t1_a4(+);
drop table t1;
commit;
--+ holdcas off;
