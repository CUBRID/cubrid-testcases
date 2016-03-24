autocommit off;
select name, multiset(select r1.name
		      from resort r1
		      where r0.activities * r1.activities <> {}
                      order by 1)
from resort r0 order by 1
rollback;
