autocommit off;
set trigger trace on;
set trigger depth 30;
create class departments_info;
create class departments as subclass of departments_info
(
        Department_id   integer,
        Department_desc string
);
create class employees as subclass of departments_info
(
        employee_name   string,
        employee_dept   integer
);
alter class departments
        add department_employees set employees;
insert into departments (Department_id, Department_desc) values
        (1, 'Department 1');
insert into departments (Department_id, Department_desc) values
        (2, 'Department 2');
insert into departments (Department_id, Department_desc) values
        (3, 'Department 3');
insert into employees values ('Kwai-On Tse', 1);
insert into employees values ('Gillian Clough', 1);
insert into employees values ('Paul Newstead', 1);
insert into employees values ('Jim Ward', 1);
insert into employees values ('Alec Waddell', 2);
insert into employees values ('Mike Terry', 2);
insert into employees values ('Dick Gent', 2);
select * from departments order by 1;
select * from employees order by 1,2;
update departments d
        set department_employees = set (select e from employees e
                where e.employee_dept = d.department_id);
select * from departments order by 1,2,3;
select department_id, department_desc, empl.employee_name
        from departments, table(department_employees) as tbl(empl) order by 1,2,3;
create trigger update_dept
after insert on employees
if obj.employee_dept is not null
        execute update departments
                set department_employees = department_employees + {obj}
                where department_id = obj.employee_dept;
insert into employees values ('Janice raine', 1);
insert into employees values ('Everton Elliott', 1);
insert into employees values ('Jeremy Boynes', 2);
insert into employees values ('Nick Evans', 1);
insert into employees values ('Mark Frost', 2);
insert into employees(Employee_name) values('Hacker Dick');
select * from departments order by 1,2,3;
select * from employees order by 1,2;
select department_id, department_desc, empl.employee_name
        from departments, table(department_employees) as tbl(empl) order by 1,2,3;
rollback work;
rollback;
