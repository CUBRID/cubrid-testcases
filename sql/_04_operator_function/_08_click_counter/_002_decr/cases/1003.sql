-- [er]create this class,insert data to this class

create class xoo ( a int, b int);
insert into xoo values(1, 1);
insert into xoo values(2, 2);

select x.a, DECR(x.b) from ( select a,b from xoo ) x where x.a = '1';

drop xoo;
