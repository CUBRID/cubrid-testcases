--join with enum types


create table join_t1(
	id int primary key auto_increment,
	color enum('yello', 'blue', 'red', 'white', 'pink', 'black'),
	_day enum('sun', 'mon', 'tue', 'wed', 'thur', 'fri', 'sat') not null,
	fruit enum('apple', 'orange', 'peach', 'banana', 'strawberry'),
	str1 enum('aaa', 'bbb', 'ccc', 'ddd')
);

insert into join_t1(color, _day, fruit, str1) values(1, 2, 3, 4);
insert into join_t1(color, _day, fruit, str1) values(2, 3, 1, 3);
insert into join_t1 set color=3, _day=4, fruit=4, str1=1;
insert into join_t1 set color=4, _day=5, fruit=3, str1=4;
insert into join_t1(color, _day, fruit, str1) values(6, 1, 5, 2);
select * from join_t1 order by 1;


create table join_t2(
	id int primary key auto_increment,
        color enum('red', 'yello', 'blue', 'white', 'black', 'pink'),
        _day enum('sun', 'mon', 'tue', 'wed', 'thur', 'fri', 'sat') not null,
        fruit enum('orange', 'peach', 'apple', 'strawberry', 'banana'),
	str2 enum('bbb', 'ddd', 'eee', 'ggg', 'zzz')
);

insert into join_t2(color, _day, fruit, str2) values(2, 4, 5, 1);
insert into join_t2(color, _day, fruit, str2) values(2, 5, 4, 2);
insert into join_t2(color, _day, fruit, str2) values(1, 4, 3, 3);
insert into join_t2(color, _day, fruit, str2) values(3, 6, 2, 4);
insert into join_t2(color, _day, fruit, str2) values(5, 2, 1, 5);
insert into join_t2(color, _day, fruit, str2) values(6, 4, 4, 4);
insert into join_t2(color, _day, fruit, str2) values(5, 4, 5, 5);
insert into join_t2(color, _day, fruit, str2) values(6, 3, 2, 3);
insert into join_t2(color, _day, fruit, str2) values(1, 1, 2, 2);
insert into join_t2(color, _day, fruit, str2) values(4, 7, 1, 1);
select * from join_t2 order by 1;


--TEST: inner join, same enum columns
select t1.id, t1.color, t2.id, t2.color from join_t1 t1, join_t2 t2 where t1.color=t2.color order by t1.id;
select * from join_t1 t1 inner join join_t2 t2 on t1._day=t2._day order by t1.id;
--TEST: inner join, different enum columns
select * from join_t1 t1, join_t2 t2 where t1.color=t2.fruit order by t1.id, t1.color, t2.id;
select * from join_t1 t1 inner join join_t2 t2 on t1.str1=t2.str2 order by 1, 2, 6;


--TEST: left outer join, same enum columns
select * from join_t1 t1 left outer join join_t2 t2 on t1._day=t2._day where t1.color > 3 order by t2.id;
select * from join_t2 t2 left outer join join_t1 t1 on t1.fruit=t2.fruit and t1.color=t2.color order by t1.id;
--TEST: left outer join, different enum columns
select * from join_t1 t1 left outer join join_t2 t2 on t1.str1=t2.str2 order by 1, 2, 6;
select * from join_t1 t1 left outer join join_t2 t2 on t1.str1=t2.str2 and t1._day=t2.fruit order by 1, 2, 6;


--TEST: right outer join, same enum columns
select * from join_t1 t1 right outer join join_t2 t2 on t1._day=t2._day where t1.str1 > 'bbb' order by 1, 2, 6;
select * from join_t2 t2 right outer join join_t1 t1 on t1.fruit=t2.fruit where t2.str2 > t1.str1 order by 1, 2, 6;
--TEST: right outer join, different enum columns
select * from join_t1 t1 right outer join join_t2 t2 on t1.str1=t2.str2 where t1._day != t2._day order by 1, 2, 6;
select * from join_t2 t2 right outer join join_t1 t1 on t1.str1=t2.color where t1.fruit=t2.fruit order by 1, 2, 6;



drop table join_t1, join_t2;


