autocommit off;
create view inventory_v3
(p joe.product_c2, q, l, s) as
select product, quantity, location, shipment_pending from joe.inventory_c
union all
select product, quantity, location, shipment_pending from joe.inventory_c2;
select * from inventory_v3;
rollback;
