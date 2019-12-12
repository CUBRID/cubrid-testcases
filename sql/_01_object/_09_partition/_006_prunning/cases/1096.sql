-- insert data  whith create hash partition class on a time field with size 8 and query data with function of to_time and then drop class

create class hash_time(id int, test_time time) 
partition by hash(test_time) partitions 8;

insert into hash_time values (1, '05:01:01');
insert into hash_time values (2, '07:15:11');
insert into hash_time values (3, '08:45:10');
insert into hash_time values (4, '11:55:10');
select * from hash_time where test_time = to_time('08:45:10','hh:mi:ss');



drop class hash_time;