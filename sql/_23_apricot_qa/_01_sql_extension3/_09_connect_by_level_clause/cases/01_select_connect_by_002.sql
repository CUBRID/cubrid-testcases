drop table if exists t;
create table t (a int, b int);

insert into t values
(1,2),
(1,4),
(2,3),
(3,4),
(3,8),
(3,11),
(4,5),
(5,6),
(6,7),
(7,8),
(8,9);
select * from t start with a=1 connect by prior b=a order by 1,2;

select * from t start with a=1 connect by prior b=a order by 2,1;
drop table if exists t;