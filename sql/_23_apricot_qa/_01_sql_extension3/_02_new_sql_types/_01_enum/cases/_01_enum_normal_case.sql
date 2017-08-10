--normal case



--TEST: create a table with an enum column
create table nc(
	id int primary key auto_increment,
	color enum('red', 'yellow', 'blue', 'white', 'green', 'pink')
);


--TEST: insert with values, one row at a time
insert into nc(color) values('red');
insert into nc(color) values('yellow');
insert into nc(color) values('blue');
insert into nc(color) values('white');
insert into nc(color) values('green');
insert into nc(color) values('pink');
--TEST: check insert result
select * from nc order by 1;


--TEST: insert with values, multiple rows at a time
insert into nc(color) values('yellow'), ('yellow'), ('yellow');
insert into nc(color) values('red'), ('pink'), ('white');
--TEST: check insert result
select * from nc where id > 6 order by 1;


--TEST: insert with index values, one row at a time
insert into nc(color) values(1);
insert into nc(color) values(2);
insert into nc(color) values(3);
insert into nc(color) values(4);
insert into nc(color) values(5);
insert into nc(color) values(6);
--TEST: check insert result
select * from nc where id > 12 order by 1;


--TEST: insert with index values, multiple rows at a time
insert into nc(color) values(1), (3), (5);
insert into nc(color) values(4), (4), (4);
--TEST: check insert result
select * from nc where id > 18 order by 1;


--TEST: insert with combination of enumeration and index values
insert into nc(color) values('pink'), (3), ('white'), (1), (5), ('yellow');
--TEST: check insert result
select * from nc where id > 24 order by 1;


drop table nc;
