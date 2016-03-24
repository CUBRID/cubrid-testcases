autocommit off;
select ssn, name, dept_no, salary, location
  from employees_v e;
delete from employees_v
 where location in (select location
                        from all inventory_v
                       where product_code = 1
                          or product_code = 2);
select ssn, name, dept_no, salary, location
  from employees_v e;
rollback work;
rollback;
