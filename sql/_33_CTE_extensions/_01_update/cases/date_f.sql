drop table if exists t;
drop view if exists v1;
create table t as
with mycte(i) as
(
SELECT DAYOFWEEK('2010-09-09')
) select * from mycte;


--create view v1 as
--with mycte as
--(
--SELECT DAYOFWEEK('2010-09-09')
--) select * from mycte;
create view v1 as select * from t;

insert into t
with mycte as
(
  select count(*) from t
  union all
  select count(*) from v1
) select * from mycte;
select * from t order by 1 desc;

with mycte as
( 
  select count(*) from t
  union all
  select count(*) from v1
) update v1 set  i=(select count(*) from mycte);

select * from v1 order by 1 desc;

with mycte as
(
  select count(*) from t
  union all
  select count(*) from v1
  union all
  select count(*) from t
) update t set  i=(select count(*) from mycte);

select * from t order by 1;

