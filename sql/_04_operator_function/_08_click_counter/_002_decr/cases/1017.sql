-- [er]create class with a double data type field,select clause with a decr function having double data type field for testing ,the report error 'Semantic: 'decr ' operator is not defined on type double.'

create class poo ( a double);
insert into poo values(1.7976931348623157e+308);
select a from poo;
select decr(a) from poo;
select a from poo;

drop poo;
