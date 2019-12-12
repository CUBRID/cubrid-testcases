--hash partition with enum column


--TEST: [er] partition not allowed
create table phash(
	id bigint primary key auto_increment,
	color enum('red', 'yello', 'blue', 'white', 'black', 'pink'),
	_day enum('sun', 'mon', 'tue', 'wed', 'thur', 'fri', 'sat'),
	fruit enum('apple', 'orange', 'peach', 'banana', 'strawberry')
)
partition by hash(color) partitions 10;



drop table if exists phash;


