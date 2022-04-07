autocommit off;
select set(select activity 
	   from all public.accommodations, table(activities) t(activity)
	   where name = 'British Colonial Beach Resort') sets
from public.resort
where country = 'Jamaica' order by sets;
rollback;
