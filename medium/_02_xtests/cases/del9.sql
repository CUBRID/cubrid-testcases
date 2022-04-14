autocommit off;
select ssn, name, dept_no, salary, location
  from joe.employees_v e;
delete from joe.employees_v
 where location in (select location
                        from all joe.inventory_v
                       where product_code = 1
                          or product_code = 2);
select ssn, name, dept_no, salary, location
  from joe.employees_v e;
rollback work;
rollback;
