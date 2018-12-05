SET SYSTEM PARAMETERS 'intl_date_lang="en_US"';
drop table if exists foo;
create table foo as
with cte as
(
  SELECT TO_TIMESTAMP('13:10:30 12/25/2008')
) select * from (select * from cte) as x(ts);
select * from foo order by 1;

insert into foo
with cte as
(
  SELECT TO_TIMESTAMP('13:10:30 12/25/2008')
) select * from cte;
select * from foo order by 1;

with cte as
(
  SELECT TO_TIMESTAMP('13:10:30 12/25/2009') as ts
) update foo,cte
set foo.ts=cte.ts;
select * from foo order by 1;

with cte as
(
  SELECT TO_TIMESTAMP('13:10:30 12/25/2010')
) delete from foo
where (select count(*) from foo) >=(select count(*) from cte);
select * from foo order by 1;

--replace
alter table foo change column ts ts timestamp unique;
insert into foo
with cte as
(
  SELECT TO_TIMESTAMP('13:10:30 12/25/2008') as ts
) select * from cte;
select * from foo order by 1;

replace into foo
with cte as
(
  SELECT TO_TIMESTAMP('13:10:30 12/25/2008')
) select * from cte;
select * from foo order by 1;


replace into foo
with cte as
(
 SELECT TO_TIMESTAMP(to_char(ts,'HH24:MI:SS MM/DD/YYYY'), 'HH24:MI:SS MM/DD/YYYY') from foo
) select * from cte;
select * from foo order by 1;

drop table if exists foo;
