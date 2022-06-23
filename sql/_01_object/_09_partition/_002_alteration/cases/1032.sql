--create hash partition table with int data type having size 4 and then rename class

create class hash_test (id int, test_char char(10))
partition by hash(id)
partitions 4;
select * from db_partition order by partition_name,partition_class_name;
rename class hash_test as hash;
select * from db_partition order by partition_name,partition_class_name;

drop class hash;
