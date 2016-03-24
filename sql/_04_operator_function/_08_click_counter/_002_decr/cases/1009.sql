-- create class,insert data to this class,using to_char() function with DECR function for testing

create class xoo ( a int);
insert into xoo values(1);

select to_char(DECR(a)) from xoo;

drop class xoo;
