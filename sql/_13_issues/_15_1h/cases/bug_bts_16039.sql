drop table if exists t;

create table t (a int, b int);
insert into t values(1,1),(2,2),(3,3);

select percentile_cont(0.2) within group (order by a) over(partition by b, a) p_cont from t order by percentile_cont(0.5) within group (order by a) over();
select percentile_cont(0.2) within group (order by a) over(partition by b, a) p_cont1, percentile_cont(0.5) within group (order by a) over() p_cont2 from t order by 1, 2;

select percentile_cont(0.2) within group (order by a) over(partition by b, a) p_cont1, percentile_cont(0.5) within group (order by a) over(partition by b, a) p_cont2 from t order by 1, 2;
select percentile_cont(0.2) within group (order by a) over(partition by b, a) p_cont1, percentile_cont(0.5) within group (order by a) over(partition by b) p_cont2 from t order by 1, 2;

drop table if exists t;

create table t (a varchar, b varchar);
insert into t values('1', '1'),('2', '2'),('3', '3');

select percentile_cont(0.2) within group (order by a) over(partition by b, a) p_cont from t order by percentile_cont(0.5) within group (order by a) over();
select percentile_cont(0.2) within group (order by a) over(partition by b, a) p_cont1, percentile_cont(0.5) within group (order by a) over() p_cont2 from t order by 1, 2;

select percentile_cont(0.2) within group (order by a) over(partition by b, a) p_cont1, percentile_cont(0.5) within group (order by a) over(partition by b, a) p_cont2 from t order by 1, 2;
select percentile_cont(0.2) within group (order by a) over(partition by b, a) p_cont1, percentile_cont(0.5) within group (order by a) over(partition by b) p_cont2 from t order by 1, 2;

drop table if exists t;
