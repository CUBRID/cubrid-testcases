-- [er]create a class,insert data to this class,select data with decr function 

create class xoo ( a int , b int);
insert into xoo values(1, 1);
insert into xoo values(2, 2);

select decr(a), decr(b) from xoo;


drop xoo;