--test for int with precision and scale



create table int_scale(
	col1 int(20), 
	col2 int(20) default -100, 
	col3 int(20) unique, 
	col4 int(20) not null,
	col5 int(20) shared 88
);


insert into int_scale(col1, col3, col4) values(23, 50.23423, -38.2389420934);
insert into int_scale(col1, col3, col4) values(56, 30.234234, -78.9023878230942);


select * from int_scale order by 1;

drop table int_scale;


--[er]
create table int_scale(col1 int(10,5) auto_increment);


