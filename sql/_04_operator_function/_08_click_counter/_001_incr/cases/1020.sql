-- [er]update clause with an incr function,reports error, incr function can be used at top select statement only

create class xoo ( a int);
insert into xoo values(1);

update  xoo x1 set x1.a = (select incr(x2.a) from xoo  x2  where x1.a = x2.a);

select * from xoo;

drop xoo;
