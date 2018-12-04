SET SYSTEM PARAMETERS 'intl_date_lang="en_US"';
drop table if exists foo;
create table foo as
with cte as
(
  SELECT TO_TIME ('13:10:30')
) select * from (select * from cte) as x(ts);
select * from foo order by 1;

insert into foo
with cte as
(
 SELECT TO_TIME ('13:10:30')
) select * from cte;
select * from foo order by 1;

with cte as
(
  SELECT TO_TIME ('14:10:30') as ts
) update foo,cte
set foo.ts=cte.ts;
select * from foo order by 1;

with cte as
(
  SELECT TO_TIME ('15:10:30')
) delete from foo
where (select count(*) from foo) >=(select count(*) from cte);
select * from foo order by 1;

--replace
alter table foo change column ts ts time unique;
insert into foo
with cte as
(
  SELECT TO_TIME ('13:10:30')
) select * from cte;
select * from foo order by 1;

replace into foo
with cte as
(
  SELECT TO_TIME ('13:10:30')
) select * from cte;
select * from foo order by 1;


replace into foo
with cte as
(
 SELECT TO_TIME(to_char(ts,'HH24:MI:SS'), 'HH24:MI:SS') from foo
) select * from cte;
select * from foo order by 1;

drop table if exists foo;
SET SYSTEM PARAMETERS 'intl_date_lang="en_US"';
