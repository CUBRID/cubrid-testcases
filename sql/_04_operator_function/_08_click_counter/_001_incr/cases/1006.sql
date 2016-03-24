-- [er]creat a class ,insert data to this calss,select data using incr(date param),then report error

create class zoo ( a date);
insert into zoo values('01/01/2001');
select incr(a) from zoo;

select * from zoo;
drop zoo;