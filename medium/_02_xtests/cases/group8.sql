autocommit off;
  select product_code, avg(price) * avg(quantity)
    from joe.inventory_v s
group by product_code
  having avg(price) * avg(quantity) > $500000;
rollback;
