--TEST: [Analytic Functions] Error occurs when analytic functions are used in ANY expression within a where clause


drop table if exists t;
drop table if exists u;

create table t(i int);
create table u(i int);

insert into t values (1);
insert into t values (2);

insert into u values (1);
insert into u values (2);


select /*+ recompile */ * from t where i > any(select row_number() over(order by i) from u) order by 1;
select /*+ recompile */ * from t where cast(i as int) > any(select row_number() over(order by i) from u) order by 1;

select /*+ recompile */ * from t where i >= all(select min(i) over(partition by i order by i) from u) order by 1;
select /*+ recompile */ * from t where cast(i as int) > all(select (max(i) over(order by i))-2 from u) order by 1;

select /*+ recompile */ * from t where i > some(select avg(i) over(order by i) aaa from u) order by 1;
select /*+ recompile */ * from t where cast(i as int) <= some(select sum(i) over(partition by i) from u) order by 1;

drop table t, u;


