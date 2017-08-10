create table f(i1 int, i2 int);

select * from f where i1 between (i2 in (0)) and true;


drop table f;
