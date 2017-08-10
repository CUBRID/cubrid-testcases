create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimeltz, datetime_col1 datetimeltz);

insert into test_class values (DATE '01/01/1901', TIME '09:00:00', TIMESTAMP '01/01/1901 00:00:00', datetimeltz '1970-01-01 00:00:00.000', datetimeltz '1970-01-01 00:00:00.999');
insert into test_class values (DATE '01/01/1971', TIME '09:00:00', TIMESTAMP '01/01/1970 00:00:00', datetimeltz '1970-01-01 00:00:00.000', datetimeltz '1970-01-01 00:00:00.999');
insert into test_class values (DATE '01/02/1971', TIME '09:00:00', TIMESTAMP '01/02/1970 00:00:00', datetimeltz '1970-01-02 00:00:00.000', datetimeltz '1970-01-02 00:00:00.999');
insert into test_class values (DATE '01/02/2009', TIME '19:10:00', TIMESTAMP '01/01/1970 12:00:00', datetimeltz '2008-01-12 12:00:00', datetimeltz '2008-02-12 12:00:00.999');

select * from test_class order by 1;

drop class test_class;