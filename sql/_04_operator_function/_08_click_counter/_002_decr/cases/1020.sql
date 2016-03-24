-- [er]update clause with an decr function,reports error, decr function can be used at top select statement only

create class xoo ( a int);
insert into xoo values(1);

update  xoo x1 set x1.a = (select decr(x2.a) from xoo  x2  where x1.a = x2.a);

select * from xoo;

drop xoo;
