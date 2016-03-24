CREATE TABLE t1 (col1 int, col2 DATE, col3 DATE);

create index idx_col1 on t1(MIN(col1));

create index idx_col1 on t1(MAX(col1));

create index idx_col1 on t1(STDDEV(col1));

drop table t1;