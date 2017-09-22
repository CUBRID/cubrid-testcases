-- create a class,insert data to this calss,select clause with incr function,select data from the class

create class xoo ( a int , b int, c int);
insert into xoo values(1, 1, 1);
insert into xoo values(2, 2, 2);

select incr(a), incr(b) from xoo where c = 1 order by 1;

select incr(a), incr(b) from xoo where c = 1 order by 1;

select incr(a), incr(b) from xoo where c = 1 order by 1;

select incr(a), incr(b) from xoo where c = 1 order by 1;

select incr(a), incr(b) from xoo where c = 1 order by 1;

select a from xoo where c = 2 WITH INCREMENT FOR  b order by 1;

select * from xoo order by 1 desc;

drop xoo;
