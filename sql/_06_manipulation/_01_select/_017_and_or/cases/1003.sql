--Test or operator with multi class
create class t1(id integer, name varchar(20), birthday date, dept_id integer);

create class t2(id integer, dept_name varchar(20));

insert into t1 values(1001, 'a', date'10/11/1980', 101);
insert into t1 values(1002, 'b', date'10/11/1980', 102);
insert into t1 values(1003, 'c', date'10/11/1981', 101);
insert into t1 values(1004, 'd', date'10/12/1980', 103);
insert into t1 values(1003, 'e', date'10/11/1981', 102);
insert into t1 values(1003, 'f', date'10/05/1982', 103);

insert into t2 values(101, 'DB');
insert into t2 values(102, 'SA');
insert into t2 values(103, 'RD');

select t1.id, t1.name 
from t1, t2
where t1.dept_id = t2.id
or  t2.dept_name = 'DB' order b 1,2;

drop class t1;
drop class t2;