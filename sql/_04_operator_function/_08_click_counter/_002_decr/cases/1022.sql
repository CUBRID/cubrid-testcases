-- [er]in select clause,there is an   decr function with varchar data type parameter

create class zoo ( a string);
insert into zoo values('1');
select decr(a) from zoo;

select * from zoo;
drop zoo;