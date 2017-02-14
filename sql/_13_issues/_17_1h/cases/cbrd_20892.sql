drop table if exists t1;
create table t1(a int, b int, c int, d int);
insert into t1 select rownum%5, rownum%10, rownum, rownum from db_class x1, db_class x2, db_class x3 limit 50000;

set @v=1;

WITH cte_4Ys3B6GHF AS
(
select * from (select (@v:=@v+1)%10 col from t1 where a>-1 and b>-1 group by col) order by 1
)
select * from cte_4Ys3B6GHF;

WITH cte(n) AS ( SELECT n+1 FROM cte WHERE n < 5 union all select 1 from db_root)SELECT * FROM cte order by 1;

WITH cte(n) AS
(
select 1 from db_root
union all
SELECT n+1 FROM cte WHERE n < 5
)
SELECT * FROM cte;

drop variable @v;
drop table if exists t1;
