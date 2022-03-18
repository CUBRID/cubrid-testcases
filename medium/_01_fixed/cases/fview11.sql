autocommit off;
select product_code, descr, price
from all joe.inventory_v i
order by descr asc;
  select product.product_code, product.descr, product.price
    from joe.inventory_c i
order by product.descr asc;
select distinct * from joe.faculty u order by fname, ssn;
select distinct descr from joe.product_c order by descr, 1 ;
select distinct descr, product_code from joe.product_c order by descr, 2, 1 asc ;
rollback;
