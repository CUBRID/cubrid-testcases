--update and delete enum values


create table upd(
	id int primary key auto_increment,
	color enum('red', 'yello', 'blue', 'white', 'black', 'pink'),
	_day enum('sun', 'mon', 'tue', 'wed', 'thur', 'fri', 'sat') not null,
	fruit enum('apple', 'orange', 'peach', 'banana', 'strawberry'),
	status enum('inserted', 'updated1', 'updated2', 'updated3', 'updated4')
);


insert into upd(color, _day, fruit, status) values(1, 1, 1, 1);
insert into upd(color, _day, fruit, status) values(2, 2, 2, 1);
insert into upd set color=3, _day=3, fruit=3, status=1;
insert into upd set color=4, _day=4, fruit=4, status=1;
insert into upd(color, _day, fruit, status) values(5, 5, 5, 1);
insert into upd(color, _day, fruit, status) select color, _day, fruit, status from upd order by color;
select * from upd order by 1;


--TEST: update multiple rows. 
update upd set status='updated1';
select if (status='updated1', 'ok', 'nok') from upd;
--TEST: [er] not null constraint 
update upd set color=3, _day=default;
--TEST: with where clause, 4 rows updated
update upd set color=6, _day=7, status=3 where fruit < 3;
select if (status=3, 'ok', 'nok') from upd where fruit < 3;
--TEST: with order by clause 
select color+0, _day+0, fruit-0 from upd order by 1,2,3;
update upd set fruit=fruit-1, _day=_day-1, color=color-1, status=4 where color > 1 and fruit > 1 order by color;
select if (fruit='apple', 'ok', 'nok') from upd where status=3;
select * from upd order by 1;
--TEST: with limit clause
update upd set id=id+100, color=1*4, fruit=100/25, status='updated4' order by _day desc limit 4;
select if (color=4 and fruit='banana', 'ok', 'nok') from upd where id > 100;

--TEST: [er] out-of-range
update upd set fruit=fruit-2, color=color+3;
--TEST: [er] invalid value
update upd set status='updated5' where _day < 'wed';
--TEST: update with another column
update upd set _day=color-1 where color < 3;
select if (_day='sun', 'ok', 'nok') from upd where color < 3;


--TEST: delete with where clause, 4 rows deleted.
delete from upd where color=4 and status=5;
select if (count(*)=6, 'ok', 'nok') from upd order by 1;
--TEST: delete with limit clause
delete from upd where fruit < 'orange' limit 1;
select if (count(*)=1, 'ok', 'nok') from upd where fruit < 'orange';
--TEST: truncate
truncate table upd;
select if (count(*)=0, 'ok', 'nok') from upd;


drop table upd;


