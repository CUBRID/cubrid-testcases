--Test function nested nullif 
Create class t1(a integer, b float(10), c integer);
insert into t1 values(100, 1919.81, null);
insert into t1 values(999, null, 999);
insert into t1 values(null, null, 888);
insert into t1 values(null, null, null);
insert into t1 values(null, 99.19, 51);
insert into t1 values(51, 99.19, 51);

select nullif(a, nullif(b,c)) from t1 order by 1;
select nullif(b, nullif(a,c)) from t1 order by 1;
select nullif(c, nullif(a,b)) from t1 where a is null order by 1;

drop table t1;
