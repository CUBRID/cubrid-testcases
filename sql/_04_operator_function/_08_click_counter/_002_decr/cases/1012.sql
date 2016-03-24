-- create a class,insert data to this calss,select clause with decr function,select data from the class

create class xoo ( a int , b int, c int);
insert into xoo values(1, 1, 1);
insert into xoo values(2, 2, 2);

select decr(a), decr(b) from xoo where c = 1;

select decr(a), decr(b) from xoo where c = 1;

select decr(a), decr(b) from xoo where c = 1;

select decr(a), decr(b) from xoo where c = 1;

select decr(a), decr(b) from xoo where c = 1;

select a from xoo where c = 2 WITH DECREMENT FOR  b;

select * from xoo;

drop xoo;
