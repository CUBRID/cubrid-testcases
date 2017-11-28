-- [er]using decr function with float data type parameter for testing ,then report error ' Semantic: 'decr ' operator is not defined on type float.'

create class zoo ( a float);
insert into zoo values(1.5);
select decr(a) from zoo;

select * from zoo;

drop zoo;
