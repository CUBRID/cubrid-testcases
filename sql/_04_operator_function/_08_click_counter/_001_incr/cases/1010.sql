-- create class,insert data,select clause with decode function with incr function parameter for testing

create class xoo ( a int);
insert into xoo values(1);

select decode(incr(a), 1, 'x', 'y') from xoo;
select decode(incr(a), 1, 'x', 'y') from xoo;
drop table xoo;
