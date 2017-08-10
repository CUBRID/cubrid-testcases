--create range partition table with int data type,insert data to this table and select data in where clause with function months_between,bit_length,octet_length

create class range_test (id int, 
			 test_int int,
			 test_char char(10))
partition by range(test_int) (
partition p0 values less than (10),
partition p1 values less than (20),
partition p2 values less than maxvalue);

insert into range_test values(0,-1,'-1');
insert into range_test values(1,1,'1');
insert into range_test values(2,2,'2');
insert into range_test values(3,11,'11');
insert into range_test values(4,12,'12');
insert into range_test values(5,21,'21');
insert into range_test values(6,22,'22');
insert into range_test values(7,2007,'2007');
insert into range_test values(8,4,'4');
insert into range_test values(9,5,'5');
insert into range_test values(10,16,'16');
select * from range_test where test_int = months_between(date '2007-12-31', date '2007-01-31') order by 1;
select * from range_test where test_int = bit_length('aa') order by 1;
select * from range_test where test_int = octet_length('a') order by 1;
select * from range_test where test_int = octet_length('aa') order by 1;
drop class range_test;
