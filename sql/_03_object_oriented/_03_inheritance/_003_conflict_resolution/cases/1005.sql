-- [er]create class and add superclass and adding attribute having same sttribute name but different type

create class employee
(emp_id integer,
 emp_name string);

create class manager
(emp_id1 integer
 );

alter class employee
add SUPERCLASS  manager;

ALTER class manager
add ATTRIBUTE emp_name int;


drop manager;
drop employee;
