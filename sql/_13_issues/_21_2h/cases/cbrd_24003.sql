drop table if exists tmp;
create table tmp (col1 int, col2 int);

drop view if exists v1;
create view v1 as
SELECT /*+ recompile */ count(*) cnt
FROM tmp A
WHERE col1 = ( SELECT col1 FROM tmp ORDER BY col2 LIMIT 1 );
