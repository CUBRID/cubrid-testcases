--insert enum values in different ways


create table ins(
	color enum('red', 'yello', 'blue', 'white', 'black', 'pink'),
	_day enum('sun', 'mon', 'tue', 'wed', 'thur', 'fri', 'sat') not null,
	fruit enum('apple', 'orange', 'peach', 'banana', 'strawberry')
);


--TEST: insert into ... values
insert into ins values('blue', 3, 'banana');
insert into ins(color, _day, fruit) values(1, 2, 3);
insert into ins(_day) values(5);
insert into ins(_day, color) values('thur', 'pink');
insert into ins(_day, fruit) values(6, 5), (3, 2), (5, 4); 
--TEST: [er] not null constraint
insert into ins(fruit) values('banana');
--TEST: [er] invalid value
insert into ins values('black', 'mon', 7);
insert into ins(_day) values(10000000000000000);
--TEST: check the result
select * from ins order by 1, 2, 3;


--TEST: insert ... set
insert into ins set color='pink', _day='sun', fruit=5;
insert into ins set _day=7;
insert into ins set _day='tue', color='white';
--TEST: [er] not null violation
insert into ins set color='red', fruit=4;
--TEST: [er] invalid values
insert into ins set color='hello', _day='sun';
insert into ins set _day=1, _day=2, _day=3, fruit=2;
insert into ins set fruit=999999, _day=0;
--TEST: check the result
select * from ins order by 1, 2, 3;


--TEST: insert ... select
insert into ins select * from ins;
insert into ins(fruit, _day, color) select fruit, _day, color from ins order by 3, 2, 1 limit 1;
insert into ins(_day) select _day from ins where _day not in ('sun', 'mon');
insert into ins(fruit, _day) select fruit, _day from ins;
--TEST: [er] not null violation
insert into ins(color, fruit) select color, fruit from ins;
--TEST: [er] invalid values
insert into ins(fruit, _day, color) select * from ins;
insert into ins(color) select * from ins;
--TEST: check the result
select if(count(*)=76, 'ok', 'nok') from ins;


drop table ins;


