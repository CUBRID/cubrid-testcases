-- [er]in select clause,there is an   incr function with varchar data type parameter,reports error ,Semantic: 'incr ' operator is not defined on type varchar.
create class zoo ( a string);
insert into zoo values('1');
select incr(a) from zoo;

select * from zoo;
drop zoo;