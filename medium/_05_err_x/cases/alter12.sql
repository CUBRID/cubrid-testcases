autocommit off;

create class joe.emp2_c
(ssn integer,
 name char(15),
 dept_no integer,
 salary string,
 location string);
 create vclass joe.employees_v;
alter vclass joe.employees_v add query
      select ssn, name, dept_no, salary, location
        from joe.emp2_c;

rollback;
