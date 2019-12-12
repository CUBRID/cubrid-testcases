create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimeltz, datetime_col1 datetimeltz);

insert into test_class values (DATE '01/01/1971', TIME '09:00:00', TIMESTAMP '01/01/1972 10:30:00', datetimeltz '1970-01-01 00:00:00.000', datetimeltz '1970-01-01 00:00:00.000');
insert into test_class values (DATE '01/02/2009', TIME '19:10:00', TIMESTAMP '01/11/2009 10:31:00', datetimeltz '2008-01-12 08:08:08.999', datetimeltz '2008-02-12 08:08:08.999');
insert into test_class values (DATE '01/02/2009', TIME '19:10:00', TIMESTAMP '01/11/2009 10:31:00', datetimeltz '2008-03-12 08:08:08.999', datetimeltz '2008-01-12 08:08:08.999');

select max(datetime_col) from test_class order by 1;
select min(datetime_col) from test_class order by 1;
select least(datetime_col, datetime_col1) from test_class order by 1;
select greatest(datetime_col, datetime_col1) from test_class order by 1;
select decode(datetime_col, datetimeltz '1970-01-01 00:00:00.000', 'EQUAL') from test_class order by 1;
select decode(datetime_col, datetimeltz '1970-01-01 00:00:00.000', 'EQUAL', 'NOT EQUAL') from test_class order by 1;

drop class test_class;