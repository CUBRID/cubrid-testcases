--test tiny int values in a function


create table medium_int (col1 int, col2 mediumint, col3 double);


insert into medium_int values(34, 44, 34.23423);
insert into medium_int values(-345, -292, -345);
insert into medium_int values(34.244, 3.244, 134.2432434);
insert into medium_int values(-53, -54234, -542346.32423);
insert into medium_int values(15896234, 15896, 15896.0101011);


select * from medium_int order by 1;

select col1+col2 from medium_int order by 1;
--select col2*col2-col1 from medium_int order by 1;
select col2/col1 from medium_int order by 1;

select greatest(col1, col2, col3) from medium_int where col2 > 100 order by 1;
select mod(col2, 3) from medium_int order by 1;
select power(col2, 3) from medium_int where col2+100 < 34 order by 1;


drop table medium_int;



