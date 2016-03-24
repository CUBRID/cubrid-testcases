autocommit off;
  select product_code 
    from all inventory_v i
group by product_code
order by product_code desc;
rollback;
