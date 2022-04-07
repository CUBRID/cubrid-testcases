autocommit off;
  select location, avg(price), max(price), min(price)
    from all joe.inventory_v i
group by location;
rollback;
