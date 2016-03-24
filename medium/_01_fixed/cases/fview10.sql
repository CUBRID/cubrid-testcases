autocommit off;
select * from all stock_v order by 1;
select * from unsold_stock_v order by 1;
select * from all inventory_v order by 1;
select product.product_code, product.descr, shipment_pending
from inventory_c i
where ( location = 'marseilles'
     or shipment_pending is null)
  and quantity > 1000 order by 1;
select *
from dated_inventory_c i
where quantity > 10 or
      ( not ( product.product_code < 3 )
        and expiry_date > '9/1/1992' ) order by 1;
select *
from dated_inventory_c d
where expiry_date <= '5/30/1992' or expiry_date > '9/1/1992' order by 1;
select *
from dated_inventory_c i
where expiry_date is null
   or expiry_date - '10/10/1992' > 30 order by 1;
  select i.product.product_code, i.product.descr, i.location,
         (i.quantity*i.product.price)
    from inventory_c i
   where (i.shipment_pending = 'no'
          or i.shipment_pending is null) order by 1;
select product_code, descr, price
from inventory_v
where price < all {$10000, $1000000} order by 1;
select product_code from dated_inventory_v
where expiry_date < '9/1/1992' order by 1;
select *
from dated_inventory_v
where expiry_date > date'9/1/1992' - 100 order by 1;
select *
from dated_inventory_c i
where expiry_date - '10/10/1992' > 30 order by 1;
select product_code, descr, price
from product_c p
where product_code > some (select product.product_code
			     from shipment_c
			    where original_loc = 'paris') order by 1;
				 	
select *
  from all inventory_c i
 where product.product_code in
       (select product.product_code
          from shipment_c
         where product.product_code in
               (select product.product_code
                  from dated_inventory_c)) order by 1;
select shipment_id, product.product_code, to_location, original_loc
  from shipment_c s
 where product.product_code > all (select product.product_code
                                     from inventory_c i
                                    where product.product_code < 3
                                      and i.location = s.original_loc) order by 1;
select shipment_id, product.product_code, to_location, original_loc
  from shipment_c s
 where product.product_code in (select product.product_code
                                  from inventory_c
                                 union
                                 
                                select product.product_code
                                  from dated_inventory_c) order by 1;
                                  
                                  
select * from all stock_v s where product_code between 2 and 5 order by 1;
select * from deficit_stock_v d where deficit_cost >= $200000 order by 1;
select * from surplus_stock_v s where surplus_cost <= $5000000 order by 1;
select product_code, descr, location, cost - 42000000
  from unsold_stock_v u
 where cost >= $2000000 order by 1;
 
 
select avg(product.price), avg(quantity)
from dated_inventory_c
where expiry_date is not null order by 1;
select sum(product.price), avg(product.price), min(product.price),
       max(product.price), count(product.price)
from inventory_c
where product.product_code > 2 order by 1;
select avg(product.price)/(max(product.price)-min(product.price))
from inventory_c order by 1;
select product_code, descr
  from unsold_stock_v u
intersection
select product_code, descr
  from deficit_stock_v d order by 1;
select max(product.price) / 1 from inventory_c;
select min(product.price) / 1 from inventory_c;
select avg(product.price)     from inventory_c;
select avg(product.price) / 1 from inventory_c;
  select product_code, avg(price), max(price), min(price)
    from all inventory_v i
group by product_code order by 1;
  select location, avg(price), max(price), min(price)
    from all inventory_v i
group by location order by 1;
  select location, avg(price), max(price), min(price)
    from all inventory_v i
group by location
  having count(location) > 1;
select * from product_v p where price between 200 and 700 order by 1;
select * from dated_inventory_v d where expiry_date between '06/06/1992' and '02/02/1993' order by 1;
/* the next ones should run ok */
(select price, descr, product_code from product_c) 
union (select price, descr, product_code from product_v) order by 1;
(select price, descr, product_code from product_c) 
intersection (select price, descr, product_code from product_v) order by 1;
(select price, descr, product_code from product_c) 
difference (select price, descr, product_code from product_v) order by 1;
select p from product_v p;
select p from unsold_stock_v p order by 1;
select price from inventory_v 
difference distinct
	select price from inventory_v where price = $ 250.0 order by 1;
rollback;
