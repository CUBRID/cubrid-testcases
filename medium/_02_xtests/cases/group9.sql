autocommit off;
  select location, quantity
    from inventory_c i
group by location, quantity;
rollback;
