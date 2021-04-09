--+ holdcas on;
CREATE TABLE t1 (col1 INTEGER, col2 DATE, col3 DATE);
--Test create index failed;
create index idx_col2 on t1(CURDATE());
drop table t1;

commit;
--+ holdcas off;
