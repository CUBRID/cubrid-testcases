--Fail to select 'SUM (distinct constant)' 
drop table if exists t;
create table t(i int);
insert into t values(1),(1),(2);

select count(distinct 4) from t;
select sum(distinct 4) from t; 
select avg(distinct 4) from t; 
select max(distinct 4) from t; 
select min(distinct 4) from t;
select count(distinct -4) from t;
select sum(distinct -4) from t; 
select avg(distinct -4) from t; 
select max(distinct -4) from t; 
select min(distinct -4) from t;
drop table t;
