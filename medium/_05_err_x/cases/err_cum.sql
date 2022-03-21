autocommit off;

select count(*), name from public.hotel;
select avg(cost) , name from public.hotel;
rollback;
