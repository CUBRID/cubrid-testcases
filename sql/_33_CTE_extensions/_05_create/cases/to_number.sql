drop table if exists foo,t;
create table t(i varchar(100),j int auto_increment);
insert into t(i) values('12,345.67');
create table foo as
with cte as
(
    select TO_NUMBER(i,'99,999.999') from t 
) select * from (select * from cte) as x(ts);
select * from foo order by 1;
describe foo;


insert into foo
with cte as
(
    select TO_NUMBER(i,'99,999.999') from t 
) select * from (select * from cte) as x(ts);
select * from foo order by 1;

with cte as
(
    select TO_NUMBER('12,345.89','99,999.999') as ts
) update foo,cte
set foo.ts=cte.ts;
select * from foo order by 1;


with cte as
(
    select TO_NUMBER('12,345.89','99,999.999') as ts
) delete from foo,t using foo,cte,t
where foo.ts=cte.ts 
and cte.ts>=( select TO_NUMBER(i,'99,999.999') from t);
select * from foo order by 1;
select * from t;

alter table foo change column ts ts numeric(8,1) unique;
insert into t(i) values('12,345.67');
insert into foo
with cte as
(
    select TO_NUMBER(i,'99,999.999') from t
) select * from cte;
select * from foo order by 1;

replace into foo
with cte as
(
    select TO_NUMBER(i,'99,999.999') from t
) select * from cte;
select * from foo order by 1;

alter table foo change column ts ts numeric(8,0) unique;
select * from foo order by 1;

with cte as
(
    select * from t
) delete from t
where (select count(*) from foo)>=(select count(*) from cte);
select * from foo order by 1;
select * from t order by 1;

insert into t(i) values(-1234);
insert into foo
with cte as
(
    select TO_NUMBER(i) from t
) select * from cte;
select * from foo order by 1;

with cte as
(
  select TO_NUMBER(i)+10 as ts from t order by 1 desc limit 1 
) update foo,cte
set foo.ts=cte.ts
where foo.ts<0;
select * from foo order by 1;

with cte as
(
    select TO_NUMBER(i) from t
) delete from foo
where (select count(*) from foo) >=(select count(*) from cte);
select * from foo order by 1;

--replace
alter table foo change column ts ts bigint unique;
insert into foo
with cte as
(
    select TO_NUMBER(i) from t
) select * from cte;
select * from foo order by 1;

replace into foo
with cte as
(
    select TO_NUMBER(i) from t
) select * from cte;
select * from foo order by 1;

drop table if exists foo,t;
