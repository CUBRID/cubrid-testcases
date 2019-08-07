drop table if exists employee;
drop view if exists v1;
create table employee (empid int ,deptid int ,salary int);
insert into employee values(1,10,5500);
insert into employee values(2,10,4500);
insert into employee values(3,20,1900);
insert into employee values(4,20,4800);
insert into employee values(5,40,6500);
insert into employee values(6,40,14500);
insert into employee values(7,40,44500);
insert into employee values(8,50,6500);
insert into employee values(9,50,7500);

create view v1 as SELECT *, row_number() OVER (partition by deptid ORDER BY salary desc) rank FROM employee;

select * from v1 order by 2, 3 desc;

select 1, 1, 1,
       1 in (concat(1, row_number() over (partition by 2 order by 3)), concat(2, row_number() over (partition by 2 order by 3 ))) from employee v1;

select 1, 1, 1,
       1 in (concat(1, row_number() over (partition by 2 order by 3)), concat(2, row_number() over (partition by 2 order by 3 ))) from employee v1;

drop view if exists v1;
drop table if exists employee;
