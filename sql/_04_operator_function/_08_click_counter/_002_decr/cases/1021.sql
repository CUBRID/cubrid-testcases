-- [er]delete clause with an decr function,reports error, decr function can be used at top select statement only

create class xoo ( a int);
insert into xoo values(1);

delete from xoo where a in (select decr(a) from xoo  x2  where  a = 6);

select * from xoo;

drop xoo;
