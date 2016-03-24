autocommit off;
select set(select activity 
	   from all accommodations, table(activities) t(activity)
	   where name = 'British Colonial Beach Resort') sets
from resort
where country = 'Jamaica' order by sets;
rollback;
