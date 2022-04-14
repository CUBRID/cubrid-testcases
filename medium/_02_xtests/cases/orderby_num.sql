autocommit off;
select distinct country
from public.hotel
where cost < $180.00 and rownum between 1 and 10
order by country;
select distinct country
from (select country, cost from public.hotel order by country) as t(country, cost)
where cost < $180.00 and rownum between 1 and 10;
select distinct country
from public.hotel
where cost < $180.00
order by country for orderby_num() between 1 and 10;
rollback work;
rollback;
