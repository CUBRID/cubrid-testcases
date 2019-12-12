--range partition with enum column


--TEST: [er] partition not allowed
create table prange(
	id bigint primary key auto_increment,
	color enum('red', 'yello', 'blue', 'white', 'black', 'pink'),
	_day enum('sun', 'mon', 'tue', 'wed', 'thur', 'fri', 'sat'),
	fruit enum('apple', 'orange', 'peach', 'banana', 'strawberry')
)
partition by range(_day)
(partition p1 values less than('tue'),
partition p2 values less than ('thur'),
partition p3 values less than('sat')
);




drop table if exists prange;


