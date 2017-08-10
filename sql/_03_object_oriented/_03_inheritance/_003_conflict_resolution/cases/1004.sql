-- [er]create class and conflict when adding superclass because having same attribute

create class employee
(emp_id integer,
 emp_name string);

create class manager
(emp_id integer,
 emp_name string);

alter class employee
add attribute SUPERCLASS  manager;

drop employee;
drop manager;
