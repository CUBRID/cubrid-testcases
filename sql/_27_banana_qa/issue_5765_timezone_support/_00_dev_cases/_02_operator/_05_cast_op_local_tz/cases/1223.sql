-- insert data  whith create range partition table on a char field witch using function of cast as int and then query all partitions and drop table
set timezone '+9:00';

create table range_test(id int not null,
				test_char char(50),
				test_varchar varchar(50),
				primary key(id, test_char))
	PARTITION BY RANGE (cast (test_char as int)) (
	PARTITION p0 VALUES LESS THAN (5),
	PARTITION p1 VALUES LESS THAN (10),
	PARTITION p2 VALUES LESS THAN MAXVALUE
	);

	insert into range_test values(1,'01','01');
	insert into range_test values(2,'02','02');
	insert into range_test values(3,'03','03');
	insert into range_test values(4,'04','04');
	insert into range_test values(5,'05','05');
	insert into range_test values(6,'06','06');
	insert into range_test values(7,'07','07');
	insert into range_test values(8,'08','08');
	insert into range_test values(9,'09','09');
	insert into range_test values(10,'10','10');
	insert into range_test values(11,'11','11');

	insert into range_test values(12, null,null);
select * from    range_test__p__p0 order by id;
select * from    range_test__p__p1 order by id;
select * from    range_test__p__p2 order by id;


drop class range_Test;set timezone 'default';
