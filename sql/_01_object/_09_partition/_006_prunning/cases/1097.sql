-- insert data  whith create hash partition class on a timestamp  field with size 8 and query data with function of to_timestamp and then drop class

create class hash_timestamp(id int, test_timestamp timestamp) 
partition by hash(test_timestamp)
partitions 8;

insert into hash_timestamp values (1, '2007-04-01 05:01:01');
insert into hash_timestamp values (2, '2007-04-01 07:15:11');
insert into hash_timestamp values (3, '2007-04-01 08:45:10');
insert into hash_timestamp values (4, '2007-04-01 11:55:10');
select * from hash_timestamp where test_timestamp = to_timestamp('2007-04-01 08:45:10', 'yyyy-mm-dd hh:mi:ss');



drop class hash_timestamp;