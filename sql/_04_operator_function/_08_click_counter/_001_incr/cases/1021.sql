-- [er]delete clause with an incr function,reports error, incr function can be used at top select statement only

create class xoo ( a int);
insert into xoo values(1);

delete from xoo where a in (select incr(a) from xoo  x2  where  a = 6);

select * from xoo;

drop xoo;
