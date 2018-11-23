drop table if exists foo;
create table foo as
with cte as
(
  SELECT STR_TO_DATE('09:30:17 20140307XEESTXEurope/Bucharest','%h:%i:%s %Y%d%mX%TZD4X%TZR')
) select * from (select * from cte) as x(ts);
select * from foo order by 1;

insert into foo
with cte as
(
    SELECT STR_TO_DATE('09:30:17 20140307XEESTXEurope/Bucharest','%h:%i:%s %Y%d%mX%TZD4X%TZR')
) select * from cte;
select * from foo order by 1;

with cte as
(
    SELECT STR_TO_DATE('09:30:17 20150307XEESTXEurope/Bucharest','%h:%i:%s %Y%d%mX%TZD4X%TZR') as ts
) update foo,cte
set foo.ts=cte.ts;
select * from foo order by 1;

with cte as
(
    SELECT STR_TO_DATE('09:30:17 20140307XEESTXEurope/Bucharest','%h:%i:%s %Y%d%mX%TZD4X%TZR')
) delete from foo
where (select count(*) from foo) >=(select count(*) from cte);
select * from foo order by 1;

--replace
alter table foo change column ts ts datetimetz unique;
insert into foo
with cte as
(
  SELECT STR_TO_DATE('09:30:17 20140307XEESTXEurope/Bucharest','%h:%i:%s %Y%d%mX%TZD4X%TZR')
) select * from cte;
select * from foo order by 1;

replace into foo
with cte as
(
  SELECT STR_TO_DATE('09:30:17 20140307XEESTXEurope/Bucharest','%h:%i:%s %Y%d%mX%TZD4X%TZR')
) select * from cte;
select * from foo order by 1;

drop table if exists foo;
