-- create class,insert data to this class,select clause with to_char(DECR(param)) for testing 

create class xoo ( a int);
insert into xoo values(1);

select to_char(DECR(a) )from xoo;
select to_char(DECR(a) )from xoo;
select to_char(DECR(a) )from xoo;

drop class xoo;
