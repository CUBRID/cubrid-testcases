--test float with precision and scale values in a function


create table float_scale (col1 int, col2 float(15, 10), col3 double);


insert into float_scale values(34, 44.092342334, 34.23423);
insert into float_scale values(-345, -292.3264234, -345);
insert into float_scale values(34.244, 3.244232343, 134.2432434);
insert into float_scale values(-5, -54.29342903, -56.32423);
insert into float_scale values(15896234, 15896.8990239049390202, 15896.0101011);


select * from float_scale order by 1;

select col1+col2 from float_scale order by 1;
select col2*col2-col1 form float_scale order by 1;
select col2/col1 from float_scale order by 1;

select greatest(col1, col2, col3) from float_scale where col2 > 100 order by 1;
select mod(col2, 3) from float_scale order by 1;
select power(col2, 3) from float_scale order by 1 where col2+100 < 34;
select max(col2);
select avg(col2);


drop table float_scale;



