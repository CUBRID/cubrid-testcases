--+ holdcas on;
CREATE TABLE t1 (i int, col2 DATE, col3 DATE);
--Test create index failed;
create index idx_col1 on t1(VERSION());
drop table t1;

commit;
--+ holdcas off;
