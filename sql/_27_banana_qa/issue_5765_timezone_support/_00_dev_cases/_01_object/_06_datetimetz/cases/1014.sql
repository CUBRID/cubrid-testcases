create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimetz);

insert into test_class(time_col) values (datetimetz '1990-01-02 23:59:59.999');
insert into test_class(time_col) values (datetimetz '2990-01-02 23:59:59.999'); 

select * from test_class;

drop class test_class;