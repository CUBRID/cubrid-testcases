--test enum columns in select statement


create table sel(
	id int primary key auto_increment,
	color enum('red', 'yello', 'blue', 'white', 'black', 'pink'),
	_day enum('sun', 'mon', 'tue', 'wed', 'thur', 'fri', 'sat') not null,
	fruit enum('apple', 'orange', 'peach', 'banana', 'strawberry'),
	status enum('inserted', 'selated1', 'selated2', 'selated3', 'selated4')
);


insert into sel(color, _day, fruit, status) values(1, 2, 3, 5);
insert into sel(color, _day, fruit, status) values(2, 3, 1, 3);
insert into sel set color=3, _day=4, fruit=4, status=1;
insert into sel set color=4, _day=5, fruit=3, status=4;
insert into sel(color, _day, fruit, status) values(6, 1, 5, 2);
insert into sel(color, _day, fruit, status) select color, _day, fruit, status from sel order by color;

select * from sel order by 1;

--TEST: select all rows. 
select all * from sel order by 1;
--TEST: select distinct rows
select distinct * from sel order by 1;
select unique color from sel order by 1;
select distinctrow _day, status from sel order by 1;

--TEST: with where clause 
select id, color+0, _day+0, fruit-0 from sel where fruit > 3 order by 1;
select * from sel where _day < 'sun' order by 1;
select id, color, fruit, color+0, fruit-0 from sel where color+fruit < 8 order by 1;
--TEST: order by enum index
select * from sel order by color, id;
select * from sel order by _day desc, id;
select * from sel order by fruit, color, status desc, id;
select * from sel order by _day, 4, 3, id;
--TEST: order by enum values
select * from sel order by cast(color as char(10)), id;
select * from sel order by cast(_day as varchar) desc, cast(fruit as varchar(20)), id;
--TEST: order by mix
select * from sel order by _day, cast(_day as varchar) desc, 1;
select * from sel order by 3, status, cast(color as char(20)) desc, 1;
--TEST: with limit clause
select * from sel order by 1 desc limit 5;
select * from sel where _day < 'sun' order by fruit desc, id limit 2;

--TEST: with group by clause
select count(distinct _day), fruit from sel group by fruit;
--TEST: with having clause
select count(status), color, fruit from sel where _day >= 'fri' group by color, fruit having color < 'yello';



drop table sel;


