create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimeltz, datetime_col1 datetimeltz);

insert into test_class values (DATE '01/01/1971', TIME '09:00:00', TIMESTAMP '01/01/1972 10:30:00', datetimeltz '1970-01-01 12:00:00.000', datetimeltz '1970-01-01 12:00:00.000');
insert into test_class values (DATE '01/02/2009', TIME '19:10:00', TIMESTAMP '01/11/2009 10:31:00', datetimeltz '2008-01-12 08:08:08.999', datetimeltz '2008-02-12 08:08:08.999');
insert into test_class values (DATE '01/02/2009', TIME '19:10:00', TIMESTAMP '01/11/2009 10:31:00', datetimeltz '2008-03-12 08:08:08.999', datetimeltz '2008-01-12 08:08:08.999');

select to_char(datetime_col) from test_class order by 1;
select to_char(datetime_col, 'CC') from test_class order by 1;
select to_char(datetime_col, 'YYYY') from test_class order by 1;
select to_char(datetime_col, 'YY') from test_class order by 1;
select to_char(datetime_col, 'Q') from test_class order by 1;
select to_char(datetime_col, 'MM') from test_class order by 1;
select to_char(datetime_col, 'MONTH') from test_class order by 1;
select to_char(datetime_col, 'MON') from test_class order by 1;
select to_char(datetime_col, 'DD') from test_class order by 1;
select to_char(datetime_col, 'DAY') from test_class order by 1;
select to_char(datetime_col, 'DY') from test_class order by 1;
select to_char(datetime_col, 'D') from test_class order by 1;
select to_char(datetime_col, 'd') from test_class order by 1;
select to_char(datetime_col, 'AM') from test_class order by 1;
select to_char(datetime_col, 'PM') from test_class order by 1;
select to_char(datetime_col, 'A.M.') from test_class order by 1;
select to_char(datetime_col, 'P.M.') from test_class order by 1;
select to_char(datetime_col, 'HH') from test_class order by 1;
select to_char(datetime_col, 'HH12') from test_class order by 1;
select to_char(datetime_col, 'HH24') from test_class order by 1;
select to_char(datetime_col, 'MI') from test_class order by 1;
select to_char(datetime_col, 'SS') from test_class order by 1;
select to_char(datetime_col, 'YYYY-MM-DD HH24:MI:SS') from test_class order by 1;
select to_char(datetime_col, 'MM/DD/YYYY HH24:MI:SS AM') from test_class order by 1;
select to_char(datetime_col, '"NHN Welcome to Year" yyyy') from test_class order by 1;
select to_char(datetime_col, '- / , . ; : "text"') from test_class order by 1;
select to_char(datetime_col, 'YYYY-MM-DD HH24:MI:SS TZR TZD TZH TZM') from test_class order by 1;

drop class test_class;