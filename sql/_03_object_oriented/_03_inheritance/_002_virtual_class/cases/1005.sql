-- change vclass to a superclass for another

create vclass employee
(emp_id integer,
 emp_name string);

create vclass manager
(emp_id1 integer,
 emp_name1 string);

alter vclass employee
add SUPERCLASS  manager;

drop employee;
drop manager;