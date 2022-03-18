autocommit off;
select name from (public.accommodations, public.resort) order by name;
rollback;
