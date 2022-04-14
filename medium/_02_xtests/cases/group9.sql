autocommit off;
  select location, quantity
    from joe.inventory_c i
group by location, quantity;
rollback;
