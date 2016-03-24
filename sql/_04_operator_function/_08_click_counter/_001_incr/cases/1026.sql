-- create a class,insert data to this class,select data from this class with incr function and null condition

create class xoo ( a int, b int);
insert into xoo values(1,1);
insert into xoo values(2,2);
insert into xoo values(3,null);

select b, incr(b) from xoo where b is null order by 1,2;

select * from xoo;

drop xoo;
