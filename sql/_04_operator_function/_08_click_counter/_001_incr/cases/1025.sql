-- create a class,insert data to this class,select data from this calss with incr function and rownun

create class xoo ( a int, b int);
insert into xoo values(1,1);
insert into xoo values(2,2);
insert into xoo values(3,3);

select * from xoo  order by 1,2;
select a, incr(b) from xoo where a = 1;
select a, incr(b) from xoo where a = 1;
select a, incr(b) from xoo where a = 1;
select * from xoo order by 1,2;

drop xoo;
