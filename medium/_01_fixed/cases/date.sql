autocommit off;
select *
from joe.dated_inventory_c d
where quantity > 10 
  and expiry_date > DATE '9/1/92';
  create class oo (u timestamp default TIMESTAMP '12/4/1992 10:45', b int);
insert into oo (b) values (9);
select * from oo;
rollback work;
insert into joe.dated_inventory_c 
(product, quantity, location, shipment_pending, expiry_date)
values (NULL, 5, 'marseilles', NULL, DATE '1/1/1993');
select max(expiry_date) from joe.dated_inventory_c;
select min(expiry_date) from joe.dated_inventory_c;
select * from joe.dated_inventory_v d 
where expiry_date >= DATE ' 6/ 6/1992'
and   expiry_date <= DATE ' 2/ 2/1993'
order by 1;
select * from joe.dated_inventory_v d 
where expiry_date >= DATE '06/06/1992'
and   expiry_date <= DATE '02/02/1993'
order by 1;
/*=== <Result of SELECT Command in Line 7> ===
  d.product_code  d.descr                            d.price   d.quantity  d.location            d.shipment_pending    d.expiry_date
====================================================================================================================================
               4  'arriere aile'                   $1,250.00           50  'paris'               'yes'                 02/02/1993   
*/
rollback;
