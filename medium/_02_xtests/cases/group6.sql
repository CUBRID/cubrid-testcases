autocommit off;
  select quantity, avg(price) * avg(quantity)
    from all joe.inventory_v i
group by quantity
  having avg(price) * avg(quantity) > $1000000;
rollback;
