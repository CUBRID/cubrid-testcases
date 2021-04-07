--+ holdcas on;
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

create index i_t1_a2q on t1(a);
create index i_t1_a2p on t1(b);
create index i_t1_a2o on t1(c);
create index i_t1_a2n on t1(d);
create index i_t1_a2m on t1(e);
create index i_t1_a2l on t1(f);
create index i_t1_a2k on t1(g);
create index i_t1_a2j on t1(h);
create index i_t1_a2i on t1(i);
create index i_t1_a2h on t1(j);
create index i_t1_a2g on t1(k);
create index i_t1_a2f on t1(l);
create index i_t1_a2e on t1(m);
create index i_t1_a2d on t1(n);
create index i_t1_a2c on t1(o);
create index i_t1_a2b on t1(p);
create index i_t1_a2a on t1(q);

insert into t1 select a,b,c,d,e,f,g+10,h,i,j,k,l,m,n,o,p,q from t1;

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
commit;
--+ holdcas off;
