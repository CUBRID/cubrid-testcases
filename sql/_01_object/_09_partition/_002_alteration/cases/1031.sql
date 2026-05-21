--create lsit partition table with char data type and then rename class

create class list_test (id int, test_char char(10))
partition by list(id) (
partition p0 values in (1,2,3,4,5),
partition p1 values in (6,7,8,9,10),
partition p2 values in (11,12,13,14,15, null)
);
select class_name, owner_name, partition_name, partition_class_name, partition_type, partition_expr, partition_values, class_partition_type, comment from db_partition order by partition_name,partition_class_name;
rename class list_test as list_t;
select class_name, owner_name, partition_name, partition_class_name, partition_type, partition_expr, partition_values, class_partition_type, comment from db_partition order by partition_name,partition_class_name;

drop class list_t;
