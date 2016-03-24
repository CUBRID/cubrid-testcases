-- create a class,insert data to this class,select data from this class with decr function and rownun
create class xoo (a int primary key, b int);
insert into xoo values(1,1);
insert into xoo values(2,2);
insert into xoo values(3,3);

select * from xoo order by 1,2;
select a, decr(b) from xoo where a > 0 and rownum = 1;
select a, decr(b) from xoo where a > 0 and rownum = 1;
select a, decr(b) from xoo where a > 0 and rownum = 1;
select * from xoo order by 1;

drop xoo;
