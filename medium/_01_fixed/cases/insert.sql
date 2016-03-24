autocommit off;
insert into shipment_c(shipment_id, product,quantity, to_location)
values( 4,
        (select product_c
           from product_c
          where product_code = 3),
        (3+2)*5,
        'milan');
                
        
insert into dated_inventory_c (product,quantity, expiry_date)
values ( (select product_c
            from product_c
           where product_code = 4),
         10,
        NULL);
insert into shipment_c(shipment_id, product,quantity, to_location)
values( (select max(shipment_id)+1
           from shipment_c),
        (select product_c
           from product_c
          where product_code = 3),
        15,
        'milan');
        
insert into product_c (product_code, descr, price)
values (8, 'rainbow colored magic unicorn thrusters', $1000000);
select * from product_c p order by 1;
select shipment_id, product.product_code, quantity, to_location
  from shipment_c s
 where product.product_code = 3 order by 1;
rollback work;
insert into shipment_c(shipment_id, product,quantity, to_location)
values( (select max(shipment_id)+1
           from shipment_c),
        (select product_c
           from product_c
          where product_code = 3),
        15,
        'milan');
select shipment_id, product.product_code, quantity, to_location
  from shipment_c s
 where product.product_code = 3 order by 1;
rollback work;
insert into inventory_c ( product) values ( insert into product_c ( product_code ) values ( 33 ) )
insert into inventory_c ( product) values ( select p from product_c p where product_code = 3 );
insert into inventory_c ( product) values ( ( select p from product_c p where product_code = 3 ) )
insert into inventory_c ( product) values (( insert into product_c ( product_code ) values ( 33 ) ))
rollback work;
create class x (a int);
create class y (b int, xs set_of x);
insert into x values (42);
insert into x values (69);
insert into y values (101, set(select x from x where a > 50));
select * from y order by 1;
rollback work;
insert into shipment_c(shipment_id, product,quantity, to_location)
values( 4,
        (select product_c
           from product_c
          where product_code = 3),
        (3+2)*5,
        'milan');
create class x (a int);
insert into x values (10);
insert into x select * from x;
select * from x order by 1;
rollback work;
create class d (a sequence(int));
insert into d(a) values(sequence{});
select * from d order by 1;
update d set a = sequence{1,2,3};
select * from d order by 1;
update d set a = sequence{};
select * from d order by 1;
create class seq (s sequence(int));
insert into seq(s) values(sequence{null, null, null});
select * from seq order by 1;
create class s(e set(string));
insert into s(e) values(set{null});
select * from s order by 1;
create class ms (e multiset());
insert into ms(e) values({null, null, null});
select * from ms order by 1;
rollback;
