-- create class,insert data to this class,using to_char() function with incr function for testing

create class xoo ( a int);
insert into xoo values(1);

select to_char(incr(a)) from xoo;

drop class xoo;
