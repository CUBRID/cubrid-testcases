-- create a class,insert data to this class,select data from this class with decr function and null condition

create class xoo ( a int, b int);
insert into xoo values(1,1);
insert into xoo values(2,2);
insert into xoo values(3,null);

select b, decr(b) from xoo where b is null;

select * from xoo;

drop xoo;
