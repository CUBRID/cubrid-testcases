drop table if exists foo;
create table foo as
with cte as
(
 SELECT TO_DATE('2008-12-25', 'YYYY-MM-DD')
) select * from (select * from cte) as x(ts);
select * from foo;

insert into foo
with cte as
(
    SELECT TO_DATE('2008-12-25', 'YYYY-MM-DD')
) select * from cte;
select * from foo;

with cte as
(
  SELECT TO_DATE('2009-12-25', 'YYYY-MM-DD') as ts
) update foo,cte
set foo.ts=cte.ts;
select * from foo order by 1;

with cte as
(
  SELECT TO_DATE('2008-12-25', 'YYYY-MM-DD')
) delete from foo
where (select count(*) from foo) >=(select count(*) from cte);
select * from foo order by 1;

--replace
alter table foo change column ts ts date unique;
insert into foo
with cte as
(
  SELECT TO_DATE('2008-12-25', 'YYYY-MM-DD')
) select * from cte;
select * from foo order by 1;

replace into foo
with cte as
(
  SELECT TO_DATE('2008-12-25', 'YYYY-MM-DD')
) select * from cte;
select * from foo order by 1;

drop table if exists foo;

