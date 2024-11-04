--TEST: [Analytic Functions] Result is inconsistent with Oracle when passing a float argument to ntile() analytic function.

drop table if exists t_ntile;

create table t_ntile (a int, b int);
insert into t_ntile values(1,2),(10,1),(2,5),(11,19),(3,7),(12,11),(20,21),(15,14),(10,5),(null,5),(10,null),(null,null);

select a,b,ntile(4.4) over (order by a,b) from t_ntile order by 1, 2, 3;
select a,b,ntile(4.5) over (order by a,b) from t_ntile order by 1, 2, 3;
select a,b,ntile(1.9) over (order by a,b) from t_ntile order by 1, 2, 3;
select a,b,ntile(2147483646.9) over (order by a,b) from t_ntile order by 1, 2, 3;
select a,b,ntile(2147483647) over (order by a,b) from t_ntile order by 1, 2, 3;
select a,b,ntile(2147483647.1) over (order by a,b) from t_ntile order by 1, 2, 3;
select a,b,ntile(2147483648) over (order by a,b) from t_ntile order by 1, 2, 3;

prepare s from 'select a,b,ntile(?) over (order by a,b) from t_ntile order by 1, 2, 3';
execute s using 4.4;
execute s using 4.5;
execute s using 1.9;
execute s using 2147483646.9;
execute s using 2147483647;
execute s using 2147483647.1;
execute s using 2147483648;
deallocate prepare s;

drop table if exists t_ntile;
 
