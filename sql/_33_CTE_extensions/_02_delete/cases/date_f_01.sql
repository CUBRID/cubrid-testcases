drop table if exists t;
drop view if exists v1;
create table t as
with mycte(i) as
(
SELECT DAYOFWEEK('0001-01-01')
) select * from mycte;

select * from t;

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
) delete from  v1 where i=(select count(*) from mycte) ;


select * from v1 order by 1 desc;
select * from t order by 1 desc;

insert into t values(123);
insert into v1 values(33);

with mycte as
(
  select count(*) from t
  union all
  select count(*) from v1
  union all
  select count(*) from t
) update t set  i=(select count(*) from mycte) where i=33;


select * from v1 order by 1 desc;
select * from t order by 1 desc;

with mycte as
(
  select count(*) from t
  union all
  select count(*) from v1
  union all
  select count(*) from t
) delete from  t where  i=(select count(*) from mycte);
select * from t order by 1;

