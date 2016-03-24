autocommit off;
  select product_code, avg(price) * avg(price)
    from all inventory_v i
group by product_code
  having avg(price) * avg(price) > $1000000;
rollback;
