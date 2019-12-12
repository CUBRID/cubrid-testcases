-- create class and add superclass and adding attribute having same sttribute name and same type and then drop superclass

create class employee
(emp_id integer,
 emp_name string);

create class manager
(emp_id1 integer
 );

alter class employee
add SUPERCLASS  manager;

ALTER class manager
add ATTRIBUTE emp_name string;


drop manager;
drop employee;
