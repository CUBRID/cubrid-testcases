autocommit off;
select product_code, descr, price
from joe.product_c p
where product_code = 1
   or price >= $40000;
rollback;
