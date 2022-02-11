--+ holdcas on;
autocommit off;
select distinct name,ssn into name1, ssn1 from faculty1;
select name, ssn from faculty1 where name = name1 and ssn = ssn1;
create class cc
class attribute(ca int default 10, cb int default 20)
(a int, b int);
insert into cc values (42, 13);
select * from class cc;

select * 
from employee_c c 
where dept_no in 
  (select dept_no 
   from employee_c 
   where name = user);
  select location, avg(price), max(price), min(price)
    from all inventory_v i
    group by location
    having location < 'mars';
create class x (a int);
select sum(a) from x;

rollback;

--+ holdcas off;
