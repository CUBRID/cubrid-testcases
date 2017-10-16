--Test nested insert 

create class person2(name varchar(20), age integer , gender char(1));
create class employees(empno integer, deptno integer, attr person2);


insert into employees values(1001, 10, (insert into person2 values ('xxx', 21, 'f')));
insert into employees values(1002, 20, (insert into person2 values ('yyy', 22, 'm')));
insert into employees values(1003, 30, (insert into person2 values ('zzz', 23, 'f')));
insert into employees values(1004, 40, (insert into person2 values ('aaa', 24, 'm')));

select * from employees order by 1;
select * from person2 order by 1;
drop class person2;
drop class employees;
