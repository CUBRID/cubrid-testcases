drop table if exists foo;
create table foo as
with cte as
(
   SELECT TO_DATETIME('13:10:30.999 12/25/2012')
) select * from (select * from cte) as x(ts);
select * from foo order by 1;

insert into foo
with cte as
(
 SELECT TO_DATETIME('13:10:30.999 12/25/2012')
) select * from cte;
select * from foo order by 1;

with cte as
(
 SELECT TO_DATETIME('13:10:30.999 12/25/2013') as ts
) update foo,cte
set foo.ts=cte.ts;
select * from foo order by 1;

with cte as
(
  SELECT TO_DATETIME('13:10:30.999 12/25/2012')
) delete from foo
where (select count(*) from foo) >=(select count(*) from cte);
select * from foo order by 1;

--replace
alter table foo change column ts ts datetime unique;
insert into foo
with cte as
(
 SELECT TO_DATETIME('13:10:30.999 12/25/2012')
) select * from cte;
select * from foo order by 1;

replace into foo
with cte as
(
 SELECT TO_DATETIME('13:10:30.999 12/25/2012')
) select * from cte;
select * from foo order by 1;

drop table if exists foo;
