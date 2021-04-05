--+ holdcas on;
CREATE TABLE t1 (col1 float, col2 DATE, col3 DATE);
--Test create index failed;
create index idx_col1 on t1(VAR_POP(col1));
drop table t1;

commit;
--+ holdcas off;
