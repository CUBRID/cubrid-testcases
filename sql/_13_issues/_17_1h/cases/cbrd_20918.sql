drop table if exists t;
create table t (i int, j int, k int, l int);
insert into t values (0,0,0,0), (0,0,1,1), (0,1,0,2), (0,1,1,3), (1,0,0,4), (1,0,1,5), (1,1,0,6), (1,1,1,7), (null, 0, 0, 8), (null, 1, 1, 9), (0, null, 0, 10), (1, null, 1, 11), (0, 0, null, 12), (1, 1, null, 13), (null, null, null, 14);

select * from t where i in (select k from t order by k desc limit 1) order by 1,2,3,4;
WITH cte_9fkpu2Lej AS
(
select * from t where i in (select k from t order by k desc limit 1) order by l
)
select * from cte_9fkpu2Lej order by 1, 2, 3, 4;

WITH cte_9fkpu2LeM AS
(
select * from t where i in (select k from t order by k desc limit 2) order by l
)
select * from cte_9fkpu2LeM order by 1, 2, 3, 4;

select * from t where i in (select min(k) from t group by k having count(k) > 3 order by k desc limit 1) order by l,2,3,4;

WITH cte_9f AS
(
select * from t where i in (select min(k) from t group by k having count(k) > 3 order by k desc limit 1) order by l,2,3,4
)
select * from cte_9f;

WITH cte_9h AS
(
select * from t where i in (select min(k) min_val from t group by k having count(k) > 3 order by min_val desc limit 1) order by l,2,3,4
)
select * from cte_9h;


drop table if exists t;
