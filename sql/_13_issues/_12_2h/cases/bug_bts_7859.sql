--TEST: [Merge Statement] 'ERROR: Invalid XASL tree node content.' error occurs when using a view as the merge source.


--CUBRIDSUS-7859
drop table if exists target;
drop table if exists source;
create table target(a int, name char(20));
insert into target values(1, 'aaa');

create table source(a int, name char(20));
insert into source values(1, 'updated');

--create source view
create view source_view as select * from source where a > 0;

--execute merge statement with source_view
merge into target t
using source_view s
on (t.a = s.a)
when matched then
update
set t.name = s.name
when not matched then
insert
values(s.a, s.name);

--execute the same merge statement again
merge into target t
using source_view s
on (t.a = s.a)
when matched then
update
set t.name = s.name
when not matched then
insert
values(s.a, s.name);

select * from target order by 1;

drop view source_view;
drop table target, source;



--CUBRIDSUS-8722
drop if exists dept;

CREATE TABLE dept (deptno int, dname string, loc string);
INSERT INTO dept VALUES
(10, 'ACCOUNTING' , 'NEW YORK'),
(20, 'RESEARCH DEV' , 'DALLAS'),
(30, 'SALES' , 'CHICAGO'),
(40, 'OPERATIONS' , 'BOSTON');

MERGE INTO dept a USING
( SELECT 50 deptno ,
'ENGINEERING' dname ,
'WEXFORD' loc ) b ON (a.deptno = b.deptno)
WHEN MATCHED THEN UPDATE SET a.loc = 'WEXFORD, PA'
WHEN NOT MATCHED THEN INSERT VALUES (b.deptno, b.dname, b.loc);
select * from dept order by 1;

--execute same merge again
MERGE INTO dept a USING
( SELECT 50 deptno ,
'ENGINEERING' dname ,
'WEXFORD' loc ) b ON (a.deptno = b.deptno)
WHEN MATCHED THEN UPDATE SET a.loc = 'WEXFORD, PA'
WHEN NOT MATCHED THEN INSERT VALUES (b.deptno, b.dname, b.loc);


select * from dept order by 1;

drop table dept;
