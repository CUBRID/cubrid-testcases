autocommit off;
select country, sum(number_of_pools) from public.hotel
group by country;
select country, sum(number_of_pools) from public.hotel
group by country having groupby_num() <= 3;
rollback work;
rollback;
