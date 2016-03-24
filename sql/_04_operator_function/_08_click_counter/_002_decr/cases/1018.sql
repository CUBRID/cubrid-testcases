-- [er]using incr function with float data type parameter for testing ,then report error ' Semantic: 'incr ' operator is not defined on type float.'

create class zoo ( a float);
insert into zoo values(1.5);
select incr(a) from zoo;

select * from zoo;

drop zoo;