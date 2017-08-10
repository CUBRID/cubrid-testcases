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

select * from t start with a=1 connect by prior b=a and level < 4 order by 1,2;

select *,level from t where level % 2 = 1 start with a=1 connect by prior b=a and level < 4 order by 1,2,3;

select *,level from t start with a=1 connect by prior b=a and level=1 order by 1,2,3;
select *,level from t start with a=1 connect by prior b=a and level=2 order by 1,2,3;
select *,level from t start with a=1 connect by prior b=a and level=3 order by 1,2,3;

select *,level from t start with a=1 connect by prior b=a and level>1 order by 1,2,3;
select *,level from t start with a=1 connect by prior b=a and level>2 order by 1,2,3;

select *,level from t start with a=1 connect by nocycle level < 4 order by 1,2,3;
-- error cases
select * from t start with a=1 connect by prior b=a and connect_by_isleaf=1;
select * from t start with a=1 connect by prior b=a and connect_by_iscycle=0;

truncate t;
insert into t values (1,1);
-- check ignore cycles
select *,level from t connect by level < 10 order by 1,2,3;
select *,level from t connect by nocycle level < 10;
select *,level from t connect by level > -1;
select *,level from t connect by level < 10 or level > -1;
select *,level from t connect by level < 10 or prior a = a;
select *,level from t connect by level < 10 or (prior a = a and level < 5) order by 1,2,3;
select *,level from t connect by level < 10 and prior a = a order by 1,2,3;
select *,level from t connect by not(level < 10);
select *,level from t connect by not(level > 10) order by 1,2,3;
select *,level from t connect by level between 1 and 10 order by 1,2,3;
select *,level from t connect by level in (1,2,3,5) order by 1,2,3;
select *,level from t connect by sqrt (level) < 3;


drop t;

select level from db_root connect by level <= 10;
select level from db_root connect by level < 10;
