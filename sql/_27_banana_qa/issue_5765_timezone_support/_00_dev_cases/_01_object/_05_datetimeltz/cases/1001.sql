create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimeltz);
alter class test_class add attribute datetime_col1 datetimeltz, datetime_col2 datetimeltz;
alter class test_class drop attribute datetime_col1, datetime_col2;
drop class test_class;