autocommit off;
(
  select product_code
    from joe.shipment_v s
union
  select product_code
    from joe.dated_inventory_v d
)
intersection
  select product_code
    from joe.unsold_stock_v u;
rollback;
