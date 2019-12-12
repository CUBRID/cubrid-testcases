--test tiny int values in a function


create table tiny_int (col1 int, col2 tinyint, col3 double);


insert into tiny_int values(34, 44, 34.23423);
insert into tiny_int values(-345, -292, -345);
insert into tiny_int values(34.244, 3.244, 134.2432434);
insert into tiny_int values(-5, -54, -56.32423);
insert into tiny_int values(15896234, 15896, 15896.0101011);


select * from tiny_int order by 1,2;

select col1+col2 from tiny_int order by 1;
--select col2*col2-col1 form tiny_int order by 1;
select col2/col1 from tiny_int order by 1;

select greatest(col1, col2, col3) from tiny_int where col2 > 100 order by 1;
select mod(col2, 3) from tiny_int order by 1;
select power(col2, 3) from tiny_int where col2+100 < 34 order by 1;


drop table tiny_int;



