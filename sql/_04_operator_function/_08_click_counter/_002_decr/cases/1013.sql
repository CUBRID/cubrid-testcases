-- create class,insert data,select clause with decr(object.attr) and  left outer join  keyword for testing

create class xoo10 ( a int, b int);
insert into xoo10 values(1, 1);
insert into xoo10 values(2, 2);
insert into xoo10 values(3, 3);
create class yoo10 ( a int, b int);
insert into xoo10 values(1, 1);
insert into xoo10 values(2, 2);
select decr(xoo10.a), decr(yoo10.b)
from xoo10, yoo10
where xoo10.a = yoo10.a;

select * from xoo10 order by 1,2;
select * from yoo10;

drop xoo10, yoo10;

create class xoo10 ( a int, b int);
insert into xoo10 values(1, 1);
insert into xoo10 values(2, 2);
insert into xoo10 values(3, 3);

create class yoo10 ( a int, b int);
insert into yoo10 values(1, 1);
insert into yoo10 values(2, 2);

select decr(xoo10.a), decr(yoo10.b)
from xoo10, yoo10
where xoo10.a = yoo10.a
 and yoo10.a = 1;

select * from xoo10 order by 1;
select * from yoo10 order by 1;

drop xoo10, yoo10;

create class xoo10 ( a int, b int);
insert into xoo10 values(1, 1);
insert into xoo10 values(2, 2);
insert into xoo10 values(3, 3);

create class yoo10 ( a int, b int);
insert into yoo10 values(1, 1);
insert into yoo10 values(2, 2);

select decr(xoo10.a), decr(yoo10.b)
from xoo10 left outer join  yoo10
on xoo10.a = yoo10.a
 where yoo10.a = 1;

select * from xoo10 order by 1;
select * from yoo10 order by 1;

drop xoo10, yoo10;
