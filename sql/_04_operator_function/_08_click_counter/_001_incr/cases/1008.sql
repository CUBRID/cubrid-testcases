-- [er]create a class with a numeric data type field,insert data to this class,select data from this class,select clause with incr function on the table's numeric field,that is an error 'Semantic: 'incr ' operator is not defined on type numeric.'

create class poo ( a numeric(3,1));
insert into poo values(1.1);
select a from poo;
select incr(a) from poo;
select a from poo;

drop poo;
