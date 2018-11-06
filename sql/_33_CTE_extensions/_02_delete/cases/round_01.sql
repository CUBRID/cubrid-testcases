drop table if exists t_delete_20181018;
create table t_delete_20181018(i int);
insert into t_delete_20181018 values(1);
WITH mycte(a) AS
(
select from_days(round(43443, 2))
)
update t_delete_20181018 set i=2 where i <=(select count(a) from mycte);


drop table if exists t;
create table t(i int);
insert into t values(1);
WITH mycte(a) AS
(
select from_days(round(43443, 2))
)
delete from  t  where i <=(select count(a) from mycte);


drop table if exists t;
create table t(i int);
insert into t values(1);
WITH mycte(a) AS
(
select from_days(11)
)
delete from  t  where i <=(select count(a) from mycte);


drop table if exists t;
create table t(i bigint);
insert into t values(1);
WITH mycte(a) AS
(
select round(43, 2)
)
delete from  t  where i <=(select count(a) from mycte);

drop table if exists t;
create table t(i bigint);
insert into t values(1);
WITH mycte(a) AS
(
SELECT ROUND(date'2012-10-26', 'yyyy')
)
delete from  t  where i <=(select count(a) from mycte);


drop table if exists t;
create table t(i int);
insert into t values(1);
WITH mycte(a) AS
(
select from_days(round(43443, 2))
)
select count(a) from mycte;

drop table if exists t;
create table t(i int);
insert into t values(1);
WITH mycte(a) AS
(
select from_days(round(43443, 2))
)
select a from mycte;



drop table if exists t;
create table t(i int);
insert into t values(1);
WITH mycte(a) AS
(
select to_char(current_timestamp)
)
delete from  t  where i <=(select count(a) from mycte);

drop table if exists t;
create table t(i int);
insert into t values(1);
WITH mycte(a) AS
(
SELECT TO_DATETIME('13:10:30 12/25/2008')
)
delete from  t  where i <=(select count(a) from mycte);


drop table if exists t;
create table t(i int);
insert into t values(1);
WITH mycte(a) AS
(
SELECT TO_DATE('12/25/2008')
)
delete from  t  where i <=(select count(a) from mycte);

WITH cte_882fQCfVe AS
(
select from_days(round(43443, 2))
)
delete from t_delete_20181018 where i <=(select count(*) from cte_882fQCfVe);


WITH cte_882fQCfVe(a) AS
(
select from_days(round(43443, 2))
)
delete from t_delete_20181018 where i <=(select count(a) from cte_882fQCfVe);
