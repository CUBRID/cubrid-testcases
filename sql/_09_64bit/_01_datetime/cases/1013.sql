create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetime);

insert into test_class(date_col) values (DATETIME '01-01-02 23:59:59.999');
insert into test_class(date_col) values (DATETIME '1990-01-02 23:59:59.999');
insert into test_class(date_col) values (DATETIME '2990-01-02 23:59:59.999');
insert into test_class(datetime_col) values (DATE '01/02/1990');
insert into test_class(datetime_col) values (DATE '01/02/2990');

select * from test_class order by 1,4;

drop class test_class;