set system parameters 'create_table_reuseoid=no';
drop table if exists t;
drop view if exists v1;
create table t as
with mycte(i) as
(
SELECT DAYOFWEEK('0001-01-01')
) select * from mycte;

insert into t
with mycte(i) as
(
SELECT DAYOFWEEK('0001-01-01')
) select * from mycte;

replace into t
with mycte(i) as
(
SELECT DAYOFWEEK('0001-01-01')
) select count(*) from mycte;

select * from t order by 1;

with mycte(i) as
(
SELECT DAYOFWEEK('0001-01-01')
) delete from t where i in (select i from mycte);


with mycte(i) as
(
SELECT DAYOFWEEK('0001-01-01')
) delete from t where i in (select * from mycte);

replace into t
with mycte(i) as
(
SELECT DAYOFWEEK('0001-01-01')
) select * from mycte;

--CBRD-22395
with mycte(i) as
(
SELECT DAYOFWEEK('0001-01-01')
) update t set i=i+1 where i=(select * from mycte);

with mycte(i) as
(
SELECT DAYOFWEEK('0001-01-01')
) update t set i=i+1 where i=(select i from mycte);


select * from t order by 1;

create view v1 as select * from t order by 1;

insert into t
with cte(i) as
(
SELECT DAYOFWEEK('0001-01-01')
),
mycte as
(
  select count(*) from cte
  union all
  select count(*) from v1
) select * from mycte;
select * from t order by 1 desc;

with cte(i) as
(
SELECT DAYOFWEEK('0001-01-01')
),
mycte as
( 
  select count(*) from cte
  union all
  select count(*) from v1
) update v1 set  i=(select count(*) from mycte);

select * from v1 order by 1 desc;


with cte(i) as
(
SELECT DAYOFWEEK('0001-01-01')
),
mycte as
(
  select count(*) from cte
  union all
  select count(*) from v1
) delete from  v1 where i=(select count(*) from mycte) ;


select * from v1 order by 1 desc;
select * from t order by 1 desc;

insert into t values(123);
insert into v1 values(33);


with cte(i) as
(
SELECT DAYOFWEEK('0001-01-01')
),
mycte as
(
  select count(*) from t
  union all
  select count(*) from v1
  union all
  select count(*) from cte
) update t set  i=(select count(*) from mycte) where i=33;


select * from v1 order by 1 desc;
select * from t order by 1 desc;


with cte(i) as
(
SELECT DAYOFWEEK('0001-01-01')
),
 mycte as
(
  select count(*) from cte
  union all
  select count(*) from v1
  union all
  select count(*) from t
) delete from  t where  i=(select count(*) from mycte);
select * from t order by 1;

drop if exists t,v1;
set system parameters 'create_table_reuseoid=yes';
