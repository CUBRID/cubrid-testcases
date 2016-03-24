autocommit off;
(
  select product_code
    from shipment_v s
union
  select product_code
    from dated_inventory_v d
)
intersection
  select product_code
    from unsold_stock_v u;
rollback;
