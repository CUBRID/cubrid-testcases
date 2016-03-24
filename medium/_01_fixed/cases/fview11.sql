autocommit off;
select product_code, descr, price
from all inventory_v i
order by descr asc;
  select product.product_code, product.descr, product.price
    from inventory_c i
order by product.descr asc;
select distinct * from faculty u order by fname, ssn;
select distinct descr from product_c order by descr, 1 ;
select distinct descr, product_code from product_c order by descr, 2, 1 asc ;
rollback;
