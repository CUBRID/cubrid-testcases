--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';

create table t1(  a char(3),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
'SQL',
'1234567890',
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

--TEST Create successfully
CREATE INDEX i_t1_a ON t1(lower (a));

--TEST: should use  index i_t1_a
select /*+ RECOMPILE */* from t1 where lower(a) = 'sql';

insert into t1 values (
'sQL',
'1234567890',
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

--TEST: should use  index i_t1_a
select /*+ RECOMPILE */* from t1 where lower(a) = 'sql';

delete from t1 where a='SQL';

--TEST: should use  index i_t1_a
select /*+ RECOMPILE */* from t1 where lower(a) = 'sql';

update t1 set a='sql' where a='sQL';

--TEST: should use  index i_t1_a
select /*+ RECOMPILE */* from t1 where lower(a) = 'sql';

--TEST: should use  index i_t1_a
select /*+ RECOMPILE */b,c,d from t1 where lower(a) = 'sql';

drop table t1;

set  system parameters 'dont_reuse_heap_file=no';

commit;

--+ holdcas off;


