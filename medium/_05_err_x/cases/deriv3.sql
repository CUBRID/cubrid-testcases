autocommit off;
select *
from   product_v p
   ,  (select baa.code
       from   inventory_v i
       where  p.product_code=i.product_code) as baa(code);
rollback;
