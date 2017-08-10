create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetimeltz, datetime_col1 datetimeltz);

insert into test_class values (DATE '01/01/1971', TIME '09:00:00', TIMESTAMP '01/01/1972 10:30:00', datetimeltz '1970-01-01 00:00:00.000', datetimeltz '1970-01-01 00:00:00.000');
insert into test_class values (DATE '01/02/2009', TIME '19:10:00', TIMESTAMP '01/11/2009 10:31:00', datetimeltz '2008-01-12 08:08:08.999', datetimeltz '2008-02-12 08:08:08.999');
insert into test_class values (DATE '01/02/2009', TIME '19:10:00', TIMESTAMP '01/11/2009 10:31:00', datetimeltz '2008-03-12 08:08:08.999', datetimeltz '2008-01-12 08:08:08.999');

select to_char(datetime_col, 'CC', 'Ko_KR') from test_class order by 1;
select to_char(datetime_col, 'YYYY', 'Ko_KR') from test_class order by 1;
select to_char(datetime_col, 'YY', 'Ko_KR') from test_class order by 1;
select to_char(datetime_col, 'Q', 'Ko_KR') from test_class order by 1;
select to_char(datetime_col, 'MM', 'Ko_KR') from test_class order by 1;
--select to_char(datetime_col, 'MONTH', 'Ko_KR') from test_class order by 1;
--move to shell/_06isssue/_12_2h/bug_bts_1025
--select to_char(datetime_col, 'MON', 'Ko_KR') from test_class order by 1;
select to_char(datetime_col, 'DD', 'Ko_KR') from test_class order by 1;
--select to_char(datetime_col, 'DAY', 'Ko_KR') from test_class order by 1;
--select to_char(datetime_col, 'DY', 'Ko_KR') from test_class order by 1;
select to_char(datetime_col, 'D', 'Ko_KR') from test_class order by 1;
select to_char(datetime_col, 'd', 'Ko_KR') from test_class order by 1;
--select to_char(datetime_col, 'AM', 'Ko_KR') from test_class order by 1;
--select to_char(datetime_col, 'PM', 'Ko_KR') from test_class order by 1;
--select to_char(datetime_col, 'A.M.', 'Ko_KR') from test_class order by 1;
--select to_char(datetime_col, 'P.M.', 'Ko_KR') from test_class order by 1;
select to_char(datetime_col, 'HH', 'Ko_KR') from test_class order by 1;
select to_char(datetime_col, 'HH12', 'Ko_KR') from test_class order by 1;
select to_char(datetime_col, 'HH24', 'Ko_KR') from test_class order by 1;
select to_char(datetime_col, 'MI', 'Ko_KR') from test_class order by 1;
select to_char(datetime_col, 'SS', 'Ko_KR') from test_class order by 1;
select to_char(datetime_col, 'YYYY-MM-DD HH24:MI:SS', 'Ko_KR') from test_class order by 1;
--select to_char(datetime_col, 'MM/DD/YYYY HH24:MI:SS AM', 'Ko_KR') from test_class order by 1;
select to_char(datetime_col, '"NHN Welcome to Year "yyyy', 'Ko_KR') from test_class order by 1;
select to_char(datetime_col, '"NHN Welcome to Year "yyyy', 'En_US') from test_class order by 1;
select to_char(datetime_col, '- / , . ; : "text"', 'En_US') from test_class order by 1;

drop class test_class;
