autocommit off;

create class emp2_c
(ssn integer,
 name char(15),
 dept_no integer,
 salary string,
 location string);
 create vclass employees_v;
alter vclass employees_v add query
      select ssn, name, dept_no, salary, location
        from emp2_c;

rollback;
