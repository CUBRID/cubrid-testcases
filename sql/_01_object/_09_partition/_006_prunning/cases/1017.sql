--create range partition table with int data type,insert data to this table and select data in where clause with function to_timestamp

create class range_timestamp(id int, test_timestamp timestamp) 
partition by range(test_timestamp) (
partition p0 values less than ('2007-04-01 06:00:00'),
partition p1 values less than ('2007-04-01 09:00:00'),
partition p2 values less than ('2007-04-01 12:00:00'),
partition p3 values less than maxvalue);

insert into range_timestamp values (1, '2007-04-01 05:01:01');
insert into range_timestamp values (2, '2007-04-01 07:15:11');
insert into range_timestamp values (3, '2007-04-01 08:45:10');
insert into range_timestamp values (4, '2007-04-01 11:55:10');
select * from range_timestamp where test_timestamp = to_timestamp('2007-04-01 08:45:10', 'yyyy-mm-dd hh:mi:ss') order by 1;



drop table range_timestamp;
