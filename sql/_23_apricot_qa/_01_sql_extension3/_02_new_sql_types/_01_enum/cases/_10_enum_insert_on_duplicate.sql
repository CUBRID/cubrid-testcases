--insert ... duplicate key update


create table ins(
	id int primary key auto_increment,
	color enum('red', 'yello', 'blue', 'white', 'black', 'pink') unique,
	_day enum('sun', 'mon', 'tue', 'wed', 'thur', 'fri', 'sat'),
	fruit enum('apple', 'orange', 'peach', 'banana', 'strawberry'),
	status enum('inserted', 'updated1', 'updated2', 'updated3')
);


--TEST: insert non-duplicate values.
insert into ins(color, _day, fruit, status) values(1, 1, 1, 1) on duplicate key update status=2;
insert into ins(color, _day, fruit, status) values(2, 2, 2, 1) on duplicate key update status=2;
insert into ins set color=3, _day=3, fruit=3, status=1 on duplicate key update status=2;
insert into ins set color=4, _day=4, fruit=4, status=1 on duplicate key update status=2;
--TEST: check the result
select * from ins order by 1;


--TEST: insert duplicate values
insert into ins select * from ins on duplicate key update status='updated1';
select if (status='updated1', 'ok', 'nok') from ins;
insert into ins(color, _day, fruit, status) values(5, 5, 5, 1), ('red', 2, 2, 1) on duplicate key update status=3;
select if (status=3, 'ok', 'nok') from ins where color=1; 
insert into ins set id=3, color='yello', fruit=5, status=1 on duplicate key update status=4, fruit='apple', _day='sun';
select if(count(*)=1, 'ok', 'nok') from ins where status=4 and fruit='apple' and _day='sun';
--TEST: [er] unique violation error
insert into ins set id=3, color='yello', fruit=5, status=1 on duplicate key update status=4, color='black', _day='sun';



drop table ins;


