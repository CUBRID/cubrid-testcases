--Test function nested COALESCE and nullif

Create class t1(a integer, b float(10), c integer);
insert into t1 values(100, 1919.81, null);
insert into t1 values(200, null, 999);
insert into t1 values(null, null, 888);
insert into t1 values(null, null, null);
insert into t1 values(null, 99.19, 51);

select nullif(a, COALESCE(b,c)) from t1 order by 1;
select COALESCE(b, nullif(a,c)) from t1 order by 1;
select COALESCE(c, nullif(a,b)) from t1 where a is null order by 1;

drop table t1;
