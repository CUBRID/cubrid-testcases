create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetime);

insert into test_class(date_col) values (DATETIME '00-00-00 23:59:59.999');
insert into test_class(time_col) values (DATETIME '01-01-01 23:59:70.999');
insert into test_class(datetime_col) values (TIME '23:59:59');
insert into test_class(datetime_col) values (TIME '01:01:01');
insert into test_class(datetime_col) values ('23:59:59');
insert into test_class(datetime_col) values ('nhn cubrid db'); 

update test_class set time_col = datetime_col;
update test_class set datetime_col = time_col;

drop class test_class;
