autocommit off;

select count(*), name from hotel;
select avg(cost) , name from hotel;
rollback;
