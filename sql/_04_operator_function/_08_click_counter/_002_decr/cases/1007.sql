-- create class,insert data,select clause with DECR function with int data type parameter for testing,create class,insert data,select clause with DECR function with smallint data type parameter for testing

create class poo ( a int);
insert into poo values(2147483647);
select a from poo;
select DECR(a) from poo;
select a from poo;

drop poo;
create class poo ( a smallint);
insert into poo values(32767);
select a from poo;
select DECR(a) from poo;
select a from poo;

drop poo;
