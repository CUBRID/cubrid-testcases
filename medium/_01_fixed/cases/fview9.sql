autocommit off;
create class product_x_rdb1 (product_code int, description string, price float);
create class inventory_x_rdb1 (prod int, qty int, location string);
create vclass inventory_x (prod product_x_rdb1, qty int, location string)
  as
    select p, qty, location
      from product_x_rdb1 p, inventory_x_rdb1 i
     where i.prod = p.product_code;
insert into product_x_rdb1 values (10, 'foo', 2.4);
insert into product_x_rdb1 values (20, 'bar', 42.0);
insert into inventory_x_rdb1 values (10, 5, 'houston');
insert into inventory_x_rdb1 values (20, 10, 'houston');
insert into inventory_x_rdb1 values (10, 10, 'dallas');
select i.qty, i.prod.description from inventory_x i order by 1;
rollback;
