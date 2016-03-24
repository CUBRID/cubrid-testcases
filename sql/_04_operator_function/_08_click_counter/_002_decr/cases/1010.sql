-- create class,insert data,select clause with decode function with DECR function parameter for testing

create class xoo ( a int);
insert into xoo values(1);

select decode(DECR(a), 1, 'x', 'y') from xoo;
select decode(DECR(a), 1, 'x', 'y') from xoo;
drop table xoo;
