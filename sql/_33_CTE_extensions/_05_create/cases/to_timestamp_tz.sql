drop table if exists foo;
create table foo as
with cte as
(
 SELECT TO_TIMESTAMP_TZ('13:10:30 Asia/Seoul 12/25/2008', 'HH24:MI:SS TZR MM/DD/YYYY')
) select * from (select * from cte) as x(tstz);
select * from foo order by 1;

insert into foo
with cte as
(
 SELECT TO_TIMESTAMP_TZ('13:10:30 Asia/Seoul 12/25/2008', 'HH24:MI:SS TZR MM/DD/YYYY')
) select * from cte;
select * from foo order by 1;

with cte as
(
 SELECT TO_TIMESTAMP_TZ('13:10:30 Asia/Seoul 12/25/2009', 'HH24:MI:SS TZR MM/DD/YYYY') as tstz
) update foo,cte
set foo.tstz=cte.tstz;
select * from foo order by 1;

with cte as
(
 SELECT TO_TIMESTAMP_TZ('13:10:30 Asia/Seoul 12/25/2009', 'HH24:MI:SS TZR MM/DD/YYYY') as tstz
) delete from foo
where (select count(*) from foo) >=(select count(*) from cte);
select * from foo order by 1;

alter table foo change column tstz tstz timestamptz unique;

insert into foo
with cte as
(
 SELECT TO_TIMESTAMP_TZ('13:10:30 Asia/Seoul 12/25/2008', 'HH24:MI:SS TZR MM/DD/YYYY')
) select * from cte;
select * from foo order by 1;


replace into foo
with cte as
(
 SELECT TO_TIMESTAMP_TZ('13:10:30 Asia/Seoul 12/25/2008', 'HH24:MI:SS TZR MM/DD/YYYY')
) select * from cte;
select * from foo order by 1;


replace into foo
with cte as
(
 SELECT TO_TIMESTAMP_TZ(to_char(tstz,'HH24:MI:SS TZR MM/DD/YYYY'), 'HH24:MI:SS TZR MM/DD/YYYY') from foo
) select * from cte;
select * from foo order by 1;

drop table if exists foo;
