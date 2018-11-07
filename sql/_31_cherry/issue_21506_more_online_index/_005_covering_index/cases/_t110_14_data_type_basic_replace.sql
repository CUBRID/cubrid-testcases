--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int primary key,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

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
insert into t1 values (null,null,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null);

create index i_t1_a on t1(a) with online;
create index i_t1_b on t1(b) with online;
create index i_t1_c on t1(c) with online;
create index i_t1_d on t1(d) with online;
create index i_t1_e on t1(e) with online;
create index i_t1_f on t1(f) with online;
create index i_t1_gh on t1(g,h) with online;
create index i_t1_h on t1(h) with online;
create index i_t1_i on t1(i) with online;
create index i_t1_j on t1(j) with online;
create index i_t1_k on t1(k) with online;
create index i_t1_l on t1(l) with online;
create index i_t1_m on t1(m) with online;
create index i_t1_n on t1(n) with online;
create index i_t1_o on t1(o) with online;
create index i_t1_p on t1(p) with online;
create index i_t1_q on t1(q) with online;

replace t1 values ('1234567890','1234567890',N'abc',N'ABC', B'1111111111', B'1111111111',11,255,9223372036854775806,0,0,0,-200,DATE '2008-10-31',TIME '00:00:00',TIMESTAMP '2010-10-31 01:15:45',DATETIME  '2008-10-31 13:15:45');

--TEST:
select /*+ recompile */ * from (select /*+ RECOMPILE */ a from t1 where a='1234567890') t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ b from t1 where b='1234567890') t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ c from t1 where c=N'abc') t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ d from t1 where d=N'ABC') t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ e from t1 where e=B'1111111111') t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ f from t1 where f=B'1111111111') t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ g from t1 where g=10) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ h from t1 where h=255) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ i from t1 where i=9223372036854775807) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ j from t1 where j=0) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ k from t1 where k=0) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ l from t1 where l=0) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ m from t1 where m=-100) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ n from t1 where n=DATE '2008-10-31') t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ o from t1 where o=TIME '00:00:00') t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ p from t1 where p=TIMESTAMP '2010-10-31 01:15:45') t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ q from t1 where q=DATETIME  '2008-10-31 13:15:45') t order by 1;

drop table t1;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
