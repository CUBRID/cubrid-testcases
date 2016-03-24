autocommit off;
  select quantity, avg(price) * avg(quantity)
    from all inventory_v i
group by quantity
  having avg(price) * avg(quantity) > $1000000;
rollback;
