create table range_test(
test_char char(120),
test_varchar varchar(2000),
test_char2 char(160));

insert into range_test values(null,'yyy',null);

update range_test set test_varchar = '1234567890_' where test_varchar ='yyy';

select * from range_test;

drop range_test;
