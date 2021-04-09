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

create index i_t1_a on t1(a) where a is not null;
create index i_t1_b on t1(b) where b='1234567890';
create index i_t1_c on t1(c) where c>=N'abc';
create index i_t1_d on t1(d) where d<=N'ABC';
create index i_t1_e on t1(e) where e>B'1111111110';
create index i_t1_f on t1(f) where f<B'1111111111';
create index i_t1_g_h on t1(g,h) where g is not null;
create index i_t1_h on t1(h) where h>=255;
create index i_t1_i on t1(i) where i=9223372036854775807;
create index i_t1_j on t1(j) where j is not null;
create index i_t1_k on t1(k) where k=0;
create index i_t1_l on t1(l) where l=0;
create index i_t1_m on t1(m) where m=-100;
create index i_t1_n on t1(n) where n=DATE '2008-10-31';
create index i_t1_o on t1(o) where o=TIME '00:00:00';
create index i_t1_p on t1(p) where p=TIMESTAMP '2010-10-31 01:15:45';
create index i_t1_q on t1(q) where q=DATETIME  '2008-10-31 13:15:45';

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
select /*+ recompile */ * from t2  using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;
select /*+ RECOMPILE */ b from t2 where b='1234567890' using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;
select /*+ RECOMPILE */ c from t2 where c=N'abc' using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;
select /*+ RECOMPILE */ d from t2 where d=N'ABC' using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;
select /*+ RECOMPILE */ e from t2 where e=B'1111111111' using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;
select /*+ RECOMPILE */ f from t2 where f=B'1111111111' using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;
select /*+ recompile */ g,h from t2 where g>0 using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;
select /*+ RECOMPILE */ h from t2 where h>=255 using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;
select /*+ recompile */ i from t2 where i=9223372036854775807 using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;
select /*+ RECOMPILE */ j from t2 where j=0 using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;
select /*+ RECOMPILE */ k from t2 where k=0 using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;
select /*+ RECOMPILE */ l from t2 where l=0 using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;
select /*+ RECOMPILE */ m from t2 where m=-100 using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;
select /*+ RECOMPILE */ n from t2 where n=DATE '2008-10-31' using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;
select /*+ RECOMPILE */ o from t2 where o=TIME '00:00:00' using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;
select /*+ RECOMPILE */ p from t2 where p=TIMESTAMP '2010-10-31 01:15:45' using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;
select /*+ RECOMPILE */ q from t2 where q=DATETIME  '2008-10-31 13:15:45' using index i_t1_a(+),i_t1_b(+),i_t1_c(+),i_t1_d(+),i_t1_e(+),i_t1_f(+),i_t1_g_h(+),i_t1_h(+),i_t1_i(+),i_t1_j(+),i_t1_k(+),i_t1_l(+),i_t1_m(+),i_t1_n(+),i_t1_o(+),i_t1_p(+),i_t1_q order by 1;


drop trigger tri_update_t2;
drop trigger tri_insert_t2;
drop table t1 ;
drop table t2 ;

commit;
--+ holdcas off;
