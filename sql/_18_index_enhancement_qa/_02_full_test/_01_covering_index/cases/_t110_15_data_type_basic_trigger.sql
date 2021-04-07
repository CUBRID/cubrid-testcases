--+ holdcas on;
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

create index i_t1_a on t1(a);
create index i_t1_b on t1(b);
create index i_t1_c on t1(c);
create index i_t1_d on t1(d);
create index i_t1_e on t1(e);
create index i_t1_f on t1(f);
create index i_t1_gh on t1(g,h);
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

create table t2 like t1;
insert into t2 select * from t1;

create trigger tri_update_t2
before update on t1 
execute replace t2 values ('update','1234567890',N'abc',N'ABC', B'1111111111', B'1111111111',11,255,9223372036854775806,0,0,0,-200,DATE '2008-10-31',TIME '00:00:00',TIMESTAMP '2010-10-31 01:15:45',DATETIME  '2008-10-31 13:15:45');

create trigger tri_insert_t2
before update on t1 
execute insert t2 values ('insert','1234567890',N'abc',N'ABC', B'1111111111', B'1111111111',12,255,9223372036854775806,0,0,0,-200,DATE '2008-10-31',TIME '00:00:00',TIMESTAMP '2010-10-31 01:15:45',DATETIME  '2008-10-31 13:15:45');

update t1 set a='0' where g=11;

--TEST:
select /*+ recompile */ * from t2 order by 1;
select /*+ RECOMPILE */ b from t2 where b='1234567890';
select /*+ RECOMPILE */ c from t2 where c=N'abc';
select /*+ RECOMPILE */ d from t2 where d=N'ABC';
select /*+ RECOMPILE */ e from t2 where e=B'1111111111';
select /*+ RECOMPILE */ f from t2 where f=B'1111111111';
select /*+ recompile */ g,h from t2 where g>0 order by 1;
select /*+ RECOMPILE */ h from t2 where h>=255;
select /*+ recompile */ i from t2 where i=9223372036854775807;
select /*+ RECOMPILE */ j from t2 where j=0;
select /*+ RECOMPILE */ k from t2 where k=0;
select /*+ RECOMPILE */ l from t2 where l=0;
select /*+ RECOMPILE */ m from t2 where m=-100;
select /*+ RECOMPILE */ n from t2 where n=DATE '2008-10-31';
select /*+ RECOMPILE */ o from t2 where o=TIME '00:00:00';
select /*+ RECOMPILE */ p from t2 where p=TIMESTAMP '2010-10-31 01:15:45';
select /*+ RECOMPILE */ q from t2 where q=DATETIME  '2008-10-31 13:15:45';


drop trigger tri_update_t2;
drop trigger tri_insert_t2;
drop table t1;
drop table t2;
commit;
--+ holdcas off;
