create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimeltz);

insert into test_class(datetime_col) values ('01/02/2990');
insert into test_class(datetime_col) values ('01/01/1970 00:00:00');

select * from test_class order by 4;

drop class test_class;