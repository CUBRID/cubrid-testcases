--Create range partition and retrieve information from db_partition
create class test_class (
transyear date,name string,amount double)
partition by range ( EXTRACT(YEAR from transyear)) (
partition p0 values less than (1990),
partition p1 values less than (2000),
partition p2 values less than MAXVALUE );

select * from db_partition
where partition_type = 'RANGE' order by 1,2,3;

drop class test_class;