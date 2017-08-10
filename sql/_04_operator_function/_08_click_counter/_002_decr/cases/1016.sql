-- [er]tests an error like : 'decr ' operator is not defined on type float.'


create class poo ( a float);
insert into poo values(3.402823e+38);
select a from poo;
select decr(a) from poo;
select a from poo;

drop poo;
