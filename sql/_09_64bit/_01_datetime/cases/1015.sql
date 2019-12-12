create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetime);

insert into test_class(timestamp_col) values (DATETIME '1990-01-02 23:59:59.999');
insert into test_class(timestamp_col) values (DATETIME '2990-01-02 23:59:59.999');
insert into test_class(timestamp_col) values (DATETIME '2038-01-01 23:59:59.888');
insert into test_class(datetime_col) values (TIMESTAMP '01/02/1990 23:59:59');
insert into test_class(datetime_col) values (TIMESTAMP '01/01/1970 12:00:00');

select * from test_class order by 3,4;

drop class test_class;