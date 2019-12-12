--test distinct with range partition class
create class test_class (
transyear date,name string,amount double)
partition by range ( EXTRACT(YEAR from transyear)) (
partition p0 values less than (1990),
partition p1 values less than (2000),
partition p2 values less than MAXVALUE );

insert into test_class values (date'05/08/1988', 'aaaaa', 15000);
insert into test_class values (date'06/08/1998', 'bbbbb', 16000);
insert into test_class values (date'07/08/2008', 'ccccc', 17000);
insert into test_class values (date'08/08/2018', 'ddddd', 18000);
insert into test_class values (date'09/08/2028', 'eeeee', 18000);
insert into test_class values (date'05/08/1988', 'aaaaa', 15000);
insert into test_class values (date'06/08/1998', 'bbbbb', 16000);
insert into test_class values (date'07/08/2008', 'ccccc', 17000);
insert into test_class values (date'08/08/2018', 'ddddd', 18000);
insert into test_class values (date'09/08/2028', 'eeeee', 18000);


select distinct transyear, name, amount from test_class;

drop class test_class;