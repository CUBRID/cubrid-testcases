--Fail to select 'SUM (distinct field)' 
drop table if exists t;
create table t(i int,j short,k double);
insert into t values(1,1,1),(1,2,2),(3,2,2);
select sum(distinct(i)),sum(distinct(j)),sum(distinct(k))  from t;
drop table t;
