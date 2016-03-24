autocommit off;
select *
  from product_c p;
delete from product_c
 where product_code < 3;
select *
  from product_c p order by 1,2; 
rollback;
