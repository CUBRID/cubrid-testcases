autocommit off;
select name, multiset(select r1.name
		      from public.resort r1
		      where r0.activities * r1.activities <> {}
                      order by 1)
from public.resort r0 order by 1;
rollback;
