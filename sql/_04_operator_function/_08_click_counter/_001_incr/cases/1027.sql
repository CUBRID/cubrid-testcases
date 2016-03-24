-- create a class,insert data to this class,test incr function with  'incr(a)+1' in a select clause 

create class xoo ( a int);
insert into xoo values(1);
select incr(a) + 1 from xoo;
drop xoo;