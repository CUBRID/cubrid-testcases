set system parameters 'create_table_reuseoid=no';
drop table if exists t;
drop view if exists v1;
create table t as
with mycte(i) as
(
SELECT DAYOFWEEK('2010-09-09')
) select * from mycte;


create view v1 as select * from t;

insert into t
with mycte as
(
  select count(*) from t
  union all
  select count(*) from v1
) select * from mycte;
select * from t order by 1 desc;


insert into t
with mycte(i) as
(
SELECT DAYOFWEEK('2010-09-09')
) select * from mycte;
select * from t order by 1 desc;

with mycte as
( 
  select count(*) from t
  union all
  select count(*) from v1
) update v1 set  i=(select count(*) from mycte) where i=1;

select * from v1 order by 1 desc;


with mycte(i) as
(
SELECT DAYOFWEEK('2010-09-09')
) update v1 set i=(select count(i) from mycte) where i not in (select i from mycte);
select * from v1 order by 1 desc;

with mycte(i) as
(
SELECT DAYOFWEEK('2010-09-09')
) update v1 set i=-1 where i=(select i from mycte);

select * from t order by 1 desc;

replace into t
with mycte(i) as
(
SELECT DAYOFWEEK('2010-09-09')
) select i from mycte;

select * from t order by 1 desc;

with mycte(i) as
(
SELECT DAYOFWEEK('2010-09-09')
) delete from v1 where i=(select i from mycte);

select * from t order by 1 desc;

with mycte as
(
  select count(*) from t
  union all
  select count(*) from v1
  union all
  select count(*) from t
) update t set  i=(select count(*) from mycte);

select * from t order by 1;

drop if exists t,v1;
set system parameters 'create_table_reuseoid=yes';
