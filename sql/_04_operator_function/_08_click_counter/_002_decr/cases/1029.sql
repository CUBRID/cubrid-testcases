-- [er]create a class,insert data to this calss,select data using decr(object.attribute) function,but the attribute is not permitted in decr()

create class xoo ( a int, b int);
insert into xoo values(1, 1);
insert into xoo values(2, 2);

select x.a, decr(x.b) from ( select a,b from xoo ) x where x.a = '1';

drop xoo;
