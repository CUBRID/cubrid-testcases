-- create class,create a class with an boject,select data using incr(attribue)

create class yoo ( a int, b int);
create class xoo ( a int, b int, c varchar(10), d yoo);
insert into xoo values(100, 1, '1', insert into yoo values(100,1));
insert into xoo values(900, 9, '9', insert into yoo values(900,9));
insert into xoo values(1000, 10, '10', insert into yoo values(1000,10));
insert into xoo values(1100, null, null, null);

select b, incr(b) from xoo where a = 1100;
select b, incr(b) from xoo where a = 1100;
select b, incr(b) from xoo where a = 1100;
select b, incr(b) from xoo where a = 1100;

drop xoo, yoo;