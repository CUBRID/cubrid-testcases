drop table if exists t;
drop view if exists v;
create table t(a int);
insert into t select rownum from db_root connect by level<=10;
create view v as select * from t;
select avg(*) from t;
select sum(*) from t;
select count(*) from t;
select max(*) from t;
select median(*) from t;
select min(*) from t;

select avg(t.*) from t;
select sum(t.*) from t;
select count(t.*) from t;
select max(t.*) from t;
select median(t.*) from t;
select min(t.*) from t;

select avg(t.a) from t;
select sum(t.a) from t;
select count(t.a) from t;
select max(t.a) from t;
select median(t.a) from t;
select min(t.a) from t;


select avg(*) from v;
select sum(*) from v;
select count(*) from v;
select max(*) from v;
select median(*) from v;
select min(*) from v;

select avg(v.*) from v;
select sum(v.*) from v;
select count(v.*) from v;
select max(v.*) from v;
select median(v.*) from v;
select min(v.*) from v;

select avg(v.a) from v;
select sum(v.a) from v;
select count(v.a) from v;
select max(v.a) from v;
select median(v.a) from v;
select min(v.a) from v;



select avg(*) from (with cte as (select * from v)select * from cte) x;
select sum(*) from (with cte as (select * from v)select * from cte) x;
select count(*) from (with cte as (select * from v)select * from cte) x;
select max(*) from (with cte as (select * from v)select * from cte) x;
select median(*) from (with cte as (select * from v)select * from cte) x;
select min(*) from (with cte as (select * from v)select * from cte) x;

select avg(x.*) from (with cte as (select * from v)select * from cte) x;
select sum(x.*) from (with cte as (select * from v)select * from cte) x;
select count(x.*) from (with cte as (select * from v)select * from cte) x;
select max(x.*) from (with cte as (select * from v)select * from cte) x;
select median(x.*) from (with cte as (select * from v)select * from cte) x;
select min(x.*) from (with cte as (select * from v)select * from cte) x;

select avg(x.a) from (with cte as (select * from v)select * from cte) x;
select sum(x.a) from (with cte as (select * from v)select * from cte) x;
select count(x.a) from (with cte as (select * from v)select * from cte) x;
select max(x.a) from (with cte as (select * from v)select * from cte) x;
select median(x.a) from (with cte as (select * from v)select * from cte) x;
select min(x.a) from (with cte as (select * from v)select * from cte) x;


drop table if exists t;
drop view if exists v;
