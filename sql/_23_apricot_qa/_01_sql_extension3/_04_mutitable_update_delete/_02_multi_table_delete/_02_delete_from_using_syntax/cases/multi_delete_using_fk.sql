--TEST: delete from 2 tables with foeign key constraint


create table dep(depid char(20) primary key, dep char(20));
insert into dep values('d01', 'aaa');
insert into dep values('d02', 'bbb');
insert into dep values('d03', 'ccc');
insert into dep values('d04', 'ddd');

create table emp(empid int primary key, name char(20), depid char(20), constraint fk_id foreign key(depid) references dep(depid) on delete cascade);
insert into emp values(1, 'aa', 'd02');
insert into emp values(2, 'bb', 'd03');
insert into emp values(3, 'cc', 'd01');
insert into emp values(4, 'dd', 'd03');
insert into emp values(5, 'aa', 'd01');
insert into emp values(6, 'ee', 'd04');
insert into emp values(7, 'ff', 'd04');



--TEST: delete from 2 tables with fk constraint, 2 rows affected, but in fact, 3 rows are deleted because of the 'on delete cascade' constraint.
delete from m1, m2 using dep m1 inner join emp m2 on m1.depid=m2.depid where m2.empid=3;
select if (count(*) =  3, 'ok', 'nok') from dep;
select case when count(*)=5 then 'ok' else 'nok' end from emp;


--TEST: delete from 2 tables with fk constraint, 1 row affected, but in fact, 3 rows are deleted because of the 'on delete cascade' constraint.
delete from m1, m2 using dep m1 inner join emp m2 on m1.depid=m2.depid where m1.depid like '_03'; 
select if (count(*) =  2, 'ok', 'nok') from dep;
select case when count(*)=3 then 'ok' else 'nok' end from emp;


--TEST: delete from 1 table, 1 row deleted
delete from m2 using dep m1 inner join emp m2 on m1.depid=m2.depid where m1.depid like '_04' and m2.name='ff';
select if (count(*) =  2, 'ok', 'nok') from dep;
select case when count(*)=2 then 'ok' else 'nok' end from emp;


select * from emp order by empid;
select * from dep order by depid;



drop table emp, dep;
