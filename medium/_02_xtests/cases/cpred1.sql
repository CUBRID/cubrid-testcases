autocommit off;
select product_code, descr, price
from product_c p
where product_code > 3
  and price >= $10000;
rollback;
