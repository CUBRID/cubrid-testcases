--prepare statements with enum type column.


create table ins(
	color enum('red', 'yello', 'blue', 'white', 'black', 'pink'),
	_day enum('sun', 'mon', 'tue', 'wed', 'thur', 'fri', 'sat') not null,
	fruit enum('apple', 'orange', 'peach', 'banana', 'strawberry')
);


--TEST: insert into ... values
prepare st from 'insert into ins values(?, ?, ?)';
execute st using 'blue', 3, 'banana';
prepare st from 'insert into ins(color, _day, fruit) values(?, ?, ?)';
execute st using 1, 2, 3;
prepare st from 'insert into ins(_day) values(?)';
execute st using 5;
prepare st from 'insert into ins(_day, color) values(?, ?)';
execute st using 'thur', 'pink';
prepare st from 'insert into ins(_day, fruit) values(?, ?), (?, ?), (?, ?)';
execute st using 6, 5, 3, 2, 5, 4; 
--TEST: [er] not null constraint
prepare st from 'insert into ins(fruit) values(?)';
execute st using 'banana';
--TEST: [er] invalid value
prepare st from 'insert into ins values(?, ?, ?)';
execute st using 'black', 'mon', 7;
--TEST: check the result, select with where condition
prepare st from 'select * from ins where color < ? order by 1';
execute st using 5;
--TEST: insert ... set
prepare st from 'insert into ins set color=?, _day=?, fruit=?';
execute st using 'pink', 'sun', 5;
select * from ins order by 1, 2, 3;


--TEST: update
prepare st from 'update ins set _day=? where fruit=?';
execute st using 1, 'peach';
--TEST: check the result
prepare st from 'select if(_day=?, ?, ?) from ins where fruit=?';
execute st using 1, 'ok', 'nok', 'peach';


--TEST: delete
prepare st from 'delete from ins where color < ? limit ?';
execute st using 5, 3;
--TEST: check the result
select if (count(*)=6, 'ok', 'nok') from ins;


--TEST: select, subquery
prepare st from 'select * from (select color, _day, fruit from ins where _day=? and fruit > ?)';
execute st using 3, 'apple';



drop table ins;


