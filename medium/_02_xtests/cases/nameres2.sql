autocommit off;
select name from (accommodations, resort) order by name;
rollback;
