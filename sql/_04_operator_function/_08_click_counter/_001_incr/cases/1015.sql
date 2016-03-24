-- create class,insert data to this class,create class,insert data,select incr(object.attribute) with left outer join keyword for testing

create class xoo ( a int, b int);
insert into xoo values(1, 1);
insert into xoo values(2, 2);
insert into xoo values(3, 3);

create class yoo ( a int, b int);
insert into yoo values(1, 1);
insert into yoo values(2, 2);

select incr(xoo.a), incr(yoo.b)
from xoo left outer join yoo on xoo.a = yoo.a
where xoo.a  = 3;

select * from xoo order by 1,2;
select * from yoo order by 1,2;


drop xoo, yoo;
