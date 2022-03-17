autocommit off;
select max(checkout_time) from all accommodations;
select min(checkout_time) from all accommodations;
rollback;
