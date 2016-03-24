SELECT TIME('2003-12-31 01:02:03');
SELECT TIME('2003-12-31 01:02:03.1234');
SELECT TIME('01:02:03');

--[er]
SELECT TIME('2003-12-31');

--select time(current_date);

select time(datetime'2000-12-31 17:34:23.1234'), if (time(datetime'2000-12-31 17:34:23.1234') = '17:34:23.123', 'ok', 'nok');
select time(timestamp'2000-12-31 17:34:23'), if (time(timestamp'2000-12-31 17:34:23') = '17:34:23', 'ok', 'nok');
select time(time'17:34:23'), if (time(time'17:34:23') = '17:34:23', 'ok', 'nok');

select time('2000-12-31 17:34:23.1234'), if (time('2000-12-31 17:34:23.1234') = '17:34:23.123', 'ok', 'nok');
select time('2000-12-31 17:34:23'), if (time('2000-12-31 17:34:23') = '17:34:23', 'ok', 'nok');
select time('17:34:23'), if (time('17:34:23') = '17:34:23', 'ok', 'nok');

select time(current_datetime), if (time(current_datetime) - time(current_time) = 0, 'ok', 'nok');
select time(current_timestamp), if (time(current_timestamp) - time(current_time) = 0, 'ok', 'nok');
select time(current_time), if (time(current_time) - time(current_time) = 0, 'ok', 'nok');

select time('00:00:00'), if (time('00:00:00') = '00:00:00', 'ok', 'nok');
select time('00:00:01'), if (time('00:00:01') = '00:00:01', 'ok', 'nok');
select time('00:01:00'), if (time('00:01:00') = '00:01:00', 'ok', 'nok');
select time('01:00:00'), if (time('01:00:00') = '01:00:00', 'ok', 'nok');
select time('03:12:30'), if (time('03:12:30') = '03:12:30', 'ok', 'nok');
select time('03:12:30.1234'), if (time('03:12:30.1234') = '03:12:30.123', 'ok', 'nok');

select time('24:00:01');
select time('00:00:60');

