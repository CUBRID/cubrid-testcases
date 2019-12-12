drop table if exists employee;
drop view if exists v1;

create table employee (empid int ,deptid int ,salary decimal(10,1));
insert into employee values(1,10,5500.00);
insert into employee values(2,10,4500.00);
insert into employee values(3,20,1900.00);
insert into employee values(4,20,4800.00);
insert into employee values(5,40,6500.00);
insert into employee values(6,40,14500.00);
insert into employee values(7,40,44500.00);
insert into employee values(8,50,6500.00);
insert into employee values(9,50,7500.00);

select *, row_number() OVER (partition by deptid ORDER BY salary desc) rank FROM employee order by deptid, salary desc;
create view v1 as SELECT *, row_number() OVER (partition by deptid ORDER BY salary desc) rank FROM employee;
select * from v1 order by deptid, salary desc;

--test: csql crashes for below:
SELECT v1.*, JSON_MERGE_PATCH(JSON_OBJECT('x', rank), JSON_OBJECT('y', rank)) FROM v1 order by deptid, salary desc;
SELECT v1.*, JSON_MERGE_PATCH(JSON_OBJECT('x', rank), JSON_OBJECT('x', rank)) FROM v1 order by deptid, salary desc;
SELECT v1.*, JSON_MERGE(JSON_OBJECT('x', rank), JSON_OBJECT('x', rank)) FROM v1 order by deptid, salary desc;

drop table if exists employee;
drop view if exists v1;

