drop table if exists t;
create table t(i int);
insert into t values(1);
WITH mycte(a) AS
(
select from_days(round(43443, 2))
)
update t set i=2 where i <=(select count(a) from mycte);
select * from t order by 1;


drop table if exists t;
create table t(i int);
insert into t values(1);
--CBRD-22529
WITH mycte(a) AS
(
select from_days(round(43443, 2))
)
delete from  t  where i <=(select count(a) from mycte);
select * from t order by 1;


drop table if exists t;
create table t(i int);
insert into t values(1);
WITH mycte(a) AS
(
select from_days(11)
)
delete from  t  where i <=(select count(a) from mycte);

select * from t order by 1;

drop table if exists t;
create table t(i bigint);
insert into t values(1);
--CBRD-22529
WITH mycte(a) AS
(
select round(43, 2)
)
delete from  t  where i <=(select count(a) from mycte);

select * from t order by 1;
drop table if exists t;
create table t(i bigint);
insert into t values(1);
WITH mycte(a) AS
(
SELECT ROUND(date'2012-10-26', 'yyyy')
)
delete from  t  where i <=(select count(a) from mycte);

select * from t order by 1;

drop table if exists t;
create table t(i int);
insert into t values(1);
WITH mycte(a) AS
(
select from_days(round(43443, 2))
)
select count(a) from mycte;

select * from t order by 1;
drop table if exists t;
create table t(i int);
insert into t values(1);
WITH mycte(a) AS
(
select from_days(round(43443, 2))
)
select a from mycte;

select * from t order by 1;


drop table if exists t;
create table t(i int);
insert into t values(1);
WITH mycte(a) AS
(
select to_char(current_timestamp)
)
delete from  t  where i <=(select count(a) from mycte);

select * from t order by 1;
drop table if exists t;
create table t(i int);
insert into t values(1);
WITH mycte(a) AS
(
SELECT TO_DATETIME('13:10:30 12/25/2008')
)
delete from  t  where i <=(select count(a) from mycte);

select * from t order by 1;

drop table if exists t;
create table t(i int);
insert into t values(1);
WITH mycte(a) AS
(
SELECT TO_DATE('12/25/2008')
)
delete from  t  where i <=(select count(a) from mycte);

select * from t order by 1;

--CBRD-22529
WITH cte AS
(
select from_days(round(43443, 2))
)
delete from t where i <=(select count(*) from cte);

select * from t order by 1;

drop table if exists t;
create table t(i bigint);
insert into t values(1);
--CBRD-22529
WITH cte(a) AS
(
select from_days(round(43443, 2))
)
delete from t where i <=(select count(a) from cte);
select * from t order by 1;

drop table if exists t;
