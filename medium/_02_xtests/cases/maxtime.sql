autocommit off;
select max(checkout_time) from all public.accommodations;
select min(checkout_time) from all public.accommodations;
rollback;
