create table t(a int);
create index idx on t(CHR());
drop table t;

CREATE TABLE t1 (i int, col2 DATE, col3 DATE);
create index idx_col1 on t1(GROUPBY_NUM());
drop table t1;