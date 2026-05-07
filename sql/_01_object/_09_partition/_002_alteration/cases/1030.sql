--create range partition table with char data type having boundary values and maxvalue and then rename class

create class range_test (id int, test_char char(1))
partition by range(test_char) (
partition p0 values less than ('aa'),
partition p1 values less than ('gg'),
partition p2 values less than ('zz'),
partition p3 values less than MAXVALUE
);
select class_name, owner_name, partition_name, partition_class_name, partition_type, partition_expr, partition_values, class_partition_type, comment from db_partition order by partition_name,partition_class_name;
select attr_name, class_name, default_value, is_partition_key from db_attribute where class_name = 'range_test' order by 1;

rename class range_test as range;
select class_name, owner_name, partition_name, partition_class_name, partition_type, partition_expr, partition_values, class_partition_type, comment from db_partition order by partition_name,partition_class_name;
select attr_name, class_name, default_value, is_partition_key from db_attribute where class_name = 'range_test' order by 1;

drop class range;
