create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimeltz);

update test_class set datetime_col = datetimeltz '0000-01-01 00:00:00.000' where datetime_col = datetimeltz '1970-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz '0000-00-00 00:00:00.000' where datetime_col = datetimeltz '1970-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz '1990-13-01 00:00:00.000' where datetime_col = datetimeltz '1970-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz '1990-01-41 00:00:00.000' where datetime_col = datetimeltz '1970-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz '1990-01-01 30:00:00.000' where datetime_col = datetimeltz '1970-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz '1990-01-01 00:90:00.000' where datetime_col = datetimeltz '1970-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz '1990-01-01 00:00:60.000' where datetime_col = datetimeltz '1970-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz '1990-01-01 00:00:60.1000' where datetime_col = datetimeltz '1970-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz '13/01/1990 00:00:00.000' where datetime_col = datetimeltz '1970-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz '01/41/1990 00:00:00.000' where datetime_col = datetimeltz '1970-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz '01/01/1990 30:00:00.000' where datetime_col = datetimeltz '1970-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz '01/01/1990 00:90:00.000' where datetime_col = datetimeltz '1970-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz '01/01/1990 00:00:60.000' where datetime_col = datetimeltz '1970-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz '01/01/1990 00:00:60.1000' where datetime_col = datetimeltz '1970-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz 'nhn cubrid db' where datetime_col = datetimeltz '1970-01-01 00:00:00.000';
update test_class set datetime_col = datetimeltz '1970-01-01 00:00:00.000' where datetime_col = datetimeltz 'nhn cubrid db';

select * from test_class;

drop class test_class;