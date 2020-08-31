-- create two class and alter one of them to be cycling inheritance
set system parameters 'create_table_reuseoid=no';

create class employee
(emp_id integer,
 emp_name string);

create class manager under employee
(staff set employee);

alter class employee
add attribute supervisor manager;

drop employee;
drop manager;

set system parameters 'create_table_reuseoid=yes';
