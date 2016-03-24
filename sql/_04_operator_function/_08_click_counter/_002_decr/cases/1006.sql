-- [er]creat a class ,insert data to this calss,select data using DECR(date param),then report error

create class zoo ( a date);
insert into zoo values('01/01/2009');
select DECR(a) from zoo;

select * from zoo;
drop zoo;