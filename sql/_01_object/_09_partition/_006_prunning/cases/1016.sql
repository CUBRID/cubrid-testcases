--create range partition table with time data type,insert data to this table and select data in where clause with function to_time

create class range_time(id int, test_time time) 
partition by range(test_time) (
partition p0 values less than ('06:00:00'),
partition p1 values less than ('09:00:00'),
partition p2 values less than ('12:00:00'),
partition p3 values less than maxvalue);

insert into range_time values (1, '05:01:01');
insert into range_time values (2, '07:15:11');
insert into range_time values (3, '08:45:10');
insert into range_time values (4, '11:55:10');
select * from range_time where test_time = to_time('08:45:10','hh:mi:ss') order by 1;



drop class range_time;
