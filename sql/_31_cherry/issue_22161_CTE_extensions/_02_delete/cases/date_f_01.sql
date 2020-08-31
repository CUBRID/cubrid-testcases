set system parameters 'create_table_reuseoid=no';
drop table if exists t,foo;
drop view if exists v1;
create table foo (i varchar);
insert into foo values('0001-01-01');
create table t as
with mycte(i) as
(
SELECT DAYOFWEEK('0001-01-01')
) select * from mycte;

select * from t order by 1;

create view v1 as select * from t;

insert into t
with mycte as
(
 SELECT DAYOFWEEK('0001-01-01')
)   select * from mycte;

insert into t
with mycte as
( 
 SELECT * from foo
)   select DAYOFWEEK(i) from mycte;

select * from t order by 1;

--CBRD-22395
with mycte as
( 
 SELECT DAYOFWEEK('0001-01-01')
) update v1 set i=(select count(*) from mycte) where i=(select * from mycte) ;

with mycte as
(
 SELECT DAYOFWEEK('0001-01-01') as i
) update v1 set i=(select count(*) from mycte) where i=(select i from mycte) ;


select * from v1 order by 1 desc;

--CBRD-22395
with mycte as
(
 SELECT DAYOFWEEK('0001-01-01')
) delete from  v1 where i=(select * from mycte);


with mycte as
(
 SELECT DAYOFWEEK('0001-01-01') as i
) delete from  v1 where i=(select i from mycte);


select * from v1 order by 1 desc;
select * from t order by 1 desc;

insert into t values(123);
insert into v1 values(33);
insert into v1 values(3);

with mycte as
(
  select count(*) from t
  union all
  select count(*) from v1
  union all
  select count(*) from t
),
mycte2 as
(
 SELECT DAYOFWEEK('0001-01-01') as i
)
update t set  i=(select i from mycte2) where i=(select count(*) from mycte);


select * from v1 order by 1 desc;
select * from t order by 1 desc;

--CBRD-22395
with mycte as
(
  select count(*) from t
  union all
  select count(*) from v1
  union all
  select count(*) from t
),
mycte2 as
(
 SELECT DAYOFWEEK('0001-01-01')
)
delete from  t where  i=(select count(*) from mycte)
or i= (select * from mycte2);
select * from t order by 1;


with mycte as
(
  select count(*) from t
  union all
  select count(*) from v1
  union all
  select count(*) from t
),
mycte2 as
(
 SELECT DAYOFWEEK('0001-01-01') as i
)
delete from  t where  i=(select count(*) from mycte)
or i= (select i from mycte2);
select * from t order by 1;
drop  if exists t,v1,foo;

set system parameters 'create_table_reuseoid=yes';
