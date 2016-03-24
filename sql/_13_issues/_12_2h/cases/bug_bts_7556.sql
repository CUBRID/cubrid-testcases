--TEST:  [FilteredIndex] Fail to create a table using LIKE statement and throw a core file about csql process(mq_reset_all_ids at ../../src/parser/view_transform.c:6064)

drop table if exists t1;
drop table if exists t2;

create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int primary key,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

create index i_t1_a on t1(a) where a is not null;
create index i_t1_b on t1(b) where b='1234567890';
create index i_t1_c on t1(c) where c>=N'abc';
create index i_t1_d on t1(d) where d<=N'ABC';
create index i_t1_e on t1(e) where e>B'1111111110';
create index i_t1_g_h on t1(g,h) where g is not null;
--should fail
create index i_t1_j on t1(j) where j<>null;


--test: below statement will throw a core file about csql process
create table t2 like t1;

show index in t2;

drop table t1;
drop table t2;


