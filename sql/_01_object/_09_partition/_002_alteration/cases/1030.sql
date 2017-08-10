--create range partition table with char data type having boundary values and maxvalue and then rename class

create class range_test (id int, test_char char(1))
partition by range(test_char) (
partition p0 values less than ('aa'),
partition p1 values less than ('gg'),
partition p2 values less than ('zz'),
partition p3 values less than MAXVALUE
);
select * from db_partition order by 1,2;
rename class range_test as range;
select * from db_partition order by 1,2;

drop class range;