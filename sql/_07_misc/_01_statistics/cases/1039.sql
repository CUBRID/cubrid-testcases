--Test update statistics on partition of range partition
create class test_range(
transyear date,name string,amount double)
partition by range ( EXTRACT(YEAR from transyear)) (
partition p0 values less than (1990),
partition p1 values less than (2000),
partition p2 values less than MAXVALUE );


update statistics on test_range__p__p0;
update statistics on test_range__p__p1;
update statistics on test_range__p__p2;


drop class test_range;