-- [er]create a class,insert data to this class,select data with incr function but have an error 'Query result does not contain a single tuple'

create class xoo ( a int , b int);
insert into xoo values(1, 1);
insert into xoo values(2, 2);

select incr(a), incr(b) from xoo;


drop xoo;