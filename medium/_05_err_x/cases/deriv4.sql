autocommit off;
select *
from   joe.product_v p
   ,  (select price
       from   joe.inventory_v i
       where  p.product_code=i.product_code) as baa(code,price);
rollback;
