--insert enum values with replace statement


create table ins(
	id int primary key auto_increment,
	color enum('red', 'yello', 'blue', 'white', 'black', 'pink') unique,
	_day enum('sun', 'mon', 'tue', 'wed', 'thur', 'fri', 'sat'),
	fruit enum('apple', 'orange', 'peach', 'banana', 'strawberry'),
	status enum('replaced', 'updated1', 'updated2', 'updated3')
);


--TEST: replace non-duplicate values.
replace into ins(color, _day, fruit, status) values(1, 1, 1, 1);
replace into ins(color, _day, fruit, status) values(2, 2, 2, 1);
replace into ins set color=3, _day=3, fruit=3, status=1;
replace into ins set color=4, _day=4, fruit=4, status=1;
--TEST: check the result
select * from ins order by 1;


--TEST: replace duplicate values
replace into ins select * from ins;
replace into ins(color, _day, fruit, status) values(5, 5, 5, 1), ('red', 2, 2, 3);
select if (status=3, 'ok', 'nok') from ins where color=1; 
--???? update 1 row and delete 1 row BUG or not???
replace into ins set id=3, color='yello', fruit=1, status=4;
select * from ins order by 1;
--TEST: [er] update 1 column twice
replace into ins set id=3, color='red', color='black', fruit=5, status=4;



drop table ins;


