--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int unique,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME)
PARTITION BY RANGE (g)
(PARTITION before_10 VALUES LESS THAN (10),
PARTITION before_20 VALUES LESS THAN (20));

insert into t1 values (
  '1234567890',
  '1234567890',
  N'abc',
  N'ABC',
  B'1111111111',
  B'1111111111',
  9,
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
insert into t1 values (null,null,null,null,null,null,8,null,null,null,null,null,null,null,null,null,null);

create index i_t1_a on t1(a);
create index i_t1_b on t1(b);
create index i_t1_c on t1(c);
create index i_t1_d on t1(d);
create index i_t1_e on t1(e);
create index i_t1_f on t1(f);
create index i_t1_gh on t1(g,h) with online;
create index i_t1_h on t1(h);
create index i_t1_i on t1(i);
create index i_t1_j on t1(j);
create index i_t1_k on t1(k);
create index i_t1_l on t1(l);
create index i_t1_m on t1(m);
create index i_t1_n on t1(n);
create index i_t1_o on t1(o);
create index i_t1_p on t1(p);
create index i_t1_q on t1(q);
insert into t1 select a,b,c,d,e,f,g+10,h,i,j,k,l,m,n,o,p,q from t1;

--TEST:
select /*+ RECOMPILE */ b from t1 where b='1234567890';
select /*+ RECOMPILE */ c from t1 where c=N'abc';
select /*+ RECOMPILE */ d from t1 where d=N'ABC';
select /*+ RECOMPILE */ e from t1 where e=B'1111111111';
select /*+ RECOMPILE */ f from t1 where f=B'1111111111';
select /*+ recompile */ g,h from t1 where g>0 order by 1;
select /*+ RECOMPILE */ h from t1 where h>=255;
select /*+ recompile */ i from t1 where i=9223372036854775807;
select /*+ RECOMPILE */ j from t1 where j=0;
select /*+ RECOMPILE */ k from t1 where k=0;
select /*+ RECOMPILE */ l from t1 where l=0;
select /*+ RECOMPILE */ m from t1 where m=-100;
select /*+ RECOMPILE */ n from t1 where n=DATE '2008-10-31';
select /*+ RECOMPILE */ o from t1 where o=TIME '00:00:00';
select /*+ RECOMPILE */ p from t1 where p=TIMESTAMP '2010-10-31 01:15:45';
select /*+ RECOMPILE */ q from t1 where q=DATETIME  '2008-10-31 13:15:45';

drop table t1;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
