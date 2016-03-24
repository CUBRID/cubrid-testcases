-- create a class,insert data to this class,test decr function with  'decr(a)+1' in a select clause 

create class xoo ( a int);
insert into xoo values(1);
select decr(a) + 1 from xoo;
drop xoo;