-- create class,insert data to this class,select clause with to_char(incr(param)) for testing 

create class xoo ( a int);
insert into xoo values(1);

select to_char(incr(a) )from xoo;
select to_char(incr(a) )from xoo;
select to_char(incr(a) )from xoo;

drop class xoo;
