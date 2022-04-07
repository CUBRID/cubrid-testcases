autocommit off;
select *
  from joe.product_c p;
delete from joe.product_c
 where product_code < 3;
select *
  from joe.product_c p order by 1,2; 
rollback;
