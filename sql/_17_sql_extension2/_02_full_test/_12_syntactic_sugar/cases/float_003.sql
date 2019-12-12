--insert marginal and out-of-range values into a float column


create table float_scale(col1 float(10, 8));

insert into float_scale values(-126.2342559);
insert into float_scale values(1276.0912309123019212);
insert into float_scale values(-300098029.23423);

select * from float_scale order by 1;

drop table float_scale;


--[er]
create table float_scale(col1 float(100, 4));
--[er]
create table float_scale(col1 float(20, 200));
drop table float_scale;
--[er]
create table float_scale(col1 float(30, -11));
drop table float_scale;







