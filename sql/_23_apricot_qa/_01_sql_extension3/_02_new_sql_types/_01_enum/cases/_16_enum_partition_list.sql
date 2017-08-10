--list partition with enum column


--TEST: [er] partition not allowed
create table plist(
	id bigint primary key auto_increment,
	color enum('red', 'yello', 'blue', 'white', 'black', 'pink'),
	_day enum('sun', 'mon', 'tue', 'wed', 'thur', 'fri', 'sat'),
	fruit enum('apple', 'orange', 'peach', 'banana', 'strawberry')
)
partition by list(fruit)
(partition p1 values in ('peach', 'banana'),
partition p2 values in ('apple', 'strawberry'),
partition p3 values in ('peach')
);




drop table if exists plist;


