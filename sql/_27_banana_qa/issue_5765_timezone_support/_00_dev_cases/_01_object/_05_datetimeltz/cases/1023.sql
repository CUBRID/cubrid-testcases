create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimeltz, datetime_col1 datetimeltz);

insert into test_class values (DATE '01/01/1971', TIME '09:00:00', TIMESTAMP '01/01/1972 10:30:00', datetimeltz '1970-01-01 12:00:00.000', datetimeltz '1970-01-01 12:00:00.000');
insert into test_class values (DATE '01/02/2009', TIME '19:10:00', TIMESTAMP '01/11/2009 10:31:00', datetimeltz '2008-01-12 08:08:08.999', datetimeltz '2008-02-12 08:08:08.999');
insert into test_class values (DATE '01/02/2009', TIME '19:10:00', TIMESTAMP '01/11/2009 10:31:00', datetimeltz '2008-03-12 08:08:08.999', datetimeltz '2008-01-12 08:08:08.999');

select cast(timestamp_col as datetimeltz) from test_class order by 1;
select cast(datetime_col as timestamp) from test_class order by 1;
select cast(datetime_col as datetimeltz) from test_class order by 1;
select cast(datetime_col as date) from test_class order by 1;
select cast(datetime_col as time) from test_class order by 1;
select cast(date_col as datetimeltz) from test_class order by 1;
select cast(datetime_col as datetimeltz) from test_class order by 1;
select cast(datetime_col as varchar) from test_class order by 1;
select cast(datetime_col as NCHAR VARYING) from test_class order by 1;
select cast(datetime_col as char(30)) from test_class order by 1;
select cast(datetime_col as nchar(30)) from test_class order by 1;
select cast(datetime_col as varchar(30)) from test_class order by 1;
select cast(datetime_col as NCHAR VARYING(30)) from test_class order by 1;

drop class test_class;