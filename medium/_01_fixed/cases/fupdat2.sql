--+ holdcas on;
autocommit off;
select x into :p1 from inventory_v x where product_code = 5;
update object :p1 set location = 'shangrila';
select product_code, location from inventory_v order by 1 desc;

rollback;

--+ holdcas off;
