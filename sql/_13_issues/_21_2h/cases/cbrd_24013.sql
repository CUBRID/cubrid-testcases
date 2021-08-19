drop table if exists t1;

create table t1 (col1 int, col2 varchar(3), col3 int, col4 int);
insert into t1 values (1, 'ABC', 2, 3), (2, 'BCD', 3, 4), (3, 'CDE', 4, 5), (4, 'DEF', 5, 6), (5, 'EFG', 6, 7);
set optimization level 513;
select /*+ recompile */ * from t1 where (col1,col2) = (select col1,col2 from t1 where col1 in (3,4) order by col4 desc limit 1);

drop table t1;
