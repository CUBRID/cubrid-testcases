
drop table if exists foo;
create table foo as
with cte(dstz) as
(
 SELECT TO_DATETIME_TZ('13:10:30 Asia/Seoul 12/25/2008', 'HH24:MI:SS TZR MM/DD/YYYY')
) select * from cte;

select * from foo order by 1;

insert into foo
with cte(dstz) as
(
 SELECT TO_DATETIME_TZ('13:10:30 Asia/Seoul 12/25/2008', 'HH24:MI:SS TZR MM/DD/YYYY')
) select * from cte;
select * from foo order by 1;

insert into foo
with cte as
(
  select * from foo 
 )
 SELECT TO_DATETIME_TZ(to_char(dstz,'HH24:MI:SS TZR MM/DD/YYYY'), 'HH24:MI:SS TZR MM/DD/YYYY') from cte;

select * from foo order by 1;

with cte(dstz) as
(
 SELECT TO_DATETIME_TZ('13:10:30 Asia/Seoul 12/25/2008', 'HH24:MI:SS TZR MM/DD/YYYY') as dstz
) delete from foo using foo,cte 
 where foo.dstz=cte.dstz;

select * from foo order by 1;

replace into foo
with cte as
(
  select * from foo
 )
 SELECT TO_DATETIME_TZ(to_char(dstz,'HH24:MI:SS TZR MM/DD/YYYY'), 'HH24:MI:SS TZR MM/DD/YYYY') from cte;

replace into foo
with cte(dstz) as
(
 SELECT TO_DATETIME_TZ('13:10:30 Asia/Seoul 12/25/2008', 'HH24:MI:SS TZR MM/DD/YYYY')
) select * from cte;

select * from foo order by 1;

with cte(dstz) as
(
 SELECT TO_DATETIME_TZ('13:10:30 Asia/Seoul 12/25/2009', 'HH24:MI:SS TZR MM/DD/YYYY') as dstz
) update foo,cte
 set foo.dstz=cte.dstz;
select * from foo order by 1;

drop table if exists foo;
