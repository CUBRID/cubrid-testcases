autocommit off;
create view inventory_v3
(p product_v2, q, l, s) as
select * from inventory_c
union all
select * from inventory_c2;
select * from inventory_v3;
rollback;
