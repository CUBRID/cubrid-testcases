create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetime);

alter class test_class rename attribute datetime_col as datetime_col1;

drop class test_class;