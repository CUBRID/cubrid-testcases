autocommit off;
update dated_inventory_c
   set quantity = 10,
       expiry_date = '9/9/1992'
 where product.product_code = 4;
update dated_inventory_c
   set quantity = 10,
       expiry_date = NULL
 where product.product_code = 4;
update product_c
set descr = 'rainbow colored msqlm> agic unicorn thrusters',
price = $1000000*3/4
where product_code = 7;
select ssn, name, dept_no, salary, location
  from employees_v e;
rollback work;
update employees_v
   set dept_no = 4,
       location = 'oxbridge'
 where location = 'marseilles'
    or location = 'surrey';
select ssn, name, dept_no, salary, location
  from employees_v e order by 1,2,3,4;
rollback work;
rollback;
