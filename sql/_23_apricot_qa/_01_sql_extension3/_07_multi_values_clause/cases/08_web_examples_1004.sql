drop table if exists employees;

create class employees (depno int primary key, sales int , salary int);

insert employees values(1,300000,5000);

insert employees values(2,350000,6000);

UPDATE employees ,(VALUES(1, 200000, 1.2), (2, 400000, 1.4)) AS v (depno, target, increase) SET salary = salary* v.increase
  WHERE employees.depno = v.depno AND employees.sales >= v.target;

select * from employees order by 1;

drop table if exists employees;