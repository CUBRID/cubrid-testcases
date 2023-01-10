-- This test case verifies CBRD-24582 issue.
-- Assert occurred during Loose index scan operation
-- Check loose index scan is used in the query plan.

drop table if exists t;
create table t(id int primary key auto_increment, a int, b int, c int, d int, e int);
insert into t (a,b,c,d, e) values (5, 5, null, null, 100);
create index i_t_all on t(a asc, b asc, c desc, d asc, e asc);

select /*+ recompile index_ls */ a,b from t where a>4 and a<7 and b>3 and b<6 group by a, b;

select /*+ recompile index_ls */ b from t where b>4 and b<7 group by  b;

drop table if exists t1;
create table t1(id int primary key auto_increment, a int, b int, c int, d int, e int, f int, g int, h int, i int);
insert into t1 (a,b,c,d,e,f,g,h,i) select mod(rownum,10), mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10),mod(rownum,10), rownum, rownum from db_class x1, db_class x2, db_class x3 limit 5000;
insert into t1 (a,b,c,d,e,f,g,h, i) values (null, null, 888, null, null, null, null, null, 0);
create index i_t1_all on t1(a,b,c,d,e,f,g,h,i);

select /*+ recompile index_ls */ a from t1 where c>0 group by a desc;

drop t, t1;
