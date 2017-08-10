create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimetz);
create index idx_datetime_col on test_class(datetime_col);
drop index idx_datetime_col on test_class;
drop class test_class;