--Test order by with alias and desc or asc

create class t1(id integer, name varchar(20), birthday date, dept_id integer);


insert into t1 values(1001, 'a', date'10/11/1980', 101);
insert into t1 values(1002, 'b', date'10/11/1980', 102);
insert into t1 values(1003, 'c', date'10/11/1981', 101);
insert into t1 values(1004, 'd', date'10/12/1980', 103);
insert into t1 values(1003, 'e', date'10/11/1981', 102);
insert into t1 values(1003, 'f', date'10/05/1982', 103);



select id, name, extract(month from birthday) as mon, dept_id
from   t1
order by mon desc,id,name,dept_id;
select id, name, birthday as age, dept_id
from t1
order by age,id,name,dept_id;


drop class t1;
