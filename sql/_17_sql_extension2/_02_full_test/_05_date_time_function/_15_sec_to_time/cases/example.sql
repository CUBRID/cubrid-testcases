--cases from dev

SELECT SEC_TO_TIME(2378);

select sec_to_time(60*60*24 - 1);

select sec_to_time(60*60*24);

select sec_to_time(2378) + 0;

select sec_to_time(2378) + 1;

select sec_to_time(2378) - 1;

select sec_to_time(0); 

select sec_to_time(-1);

select sec_to_time(1000000000);

select sec_to_time('2378');


-- test for valid date time format
select sec_to_time(time_to_sec(datetime'2000-12-31 17:34:23.1234')), if (sec_to_time(time_to_sec(datetime'2000-12-31 17:34:23.1234')) = '17:34:23', 'ok', 'nok');
select sec_to_time(time_to_sec(timestamp'2000-12-31 17:34:23')), if (sec_to_time(time_to_sec(timestamp'2000-12-31 17:34:23')) = '17:34:23', 'ok', 'nok');
select sec_to_time(time_to_sec(time'17:34:23')), if (sec_to_time(time_to_sec(time'17:34:23')) = '17:34:23', 'ok', 'nok');


-- test for valid date, time string format
select sec_to_time(time_to_sec('2000-12-31 17:34:23.1234')), if (sec_to_time(time_to_sec('2000-12-31 17:34:23.1234')) = '17:34:23', 'ok', 'nok');
select sec_to_time(time_to_sec('2000-12-31 17:34:23')), if (sec_to_time(time_to_sec('2000-12-31 17:34:23')) = '17:34:23', 'ok', 'nok');
select sec_to_time(time_to_sec('17:34:23')), if (sec_to_time(time_to_sec('17:34:23')) = '17:34:23', 'ok', 'nok');


-- test for valid current_*
select if (sec_to_time(time_to_sec(current_datetime)) - current_time = 0, 'ok', 'nok');
select if (sec_to_time(time_to_sec(current_timestamp)) - current_time = 0, 'ok', 'nok');
select if (sec_to_time(time_to_sec(current_time)) - current_time = 0, 'ok', 'nok');


-- test for normal case
select sec_to_time(0), if (sec_to_time(0) = '00:00:00', 'ok', 'nok');
select sec_to_time(1), if (sec_to_time(1) = '00:00:01', 'ok', 'nok');
select sec_to_time(60), if (sec_to_time(60) = '00:01:00', 'ok', 'nok');
select sec_to_time(60*60), if (sec_to_time(60*60) = '01:00:00', 'ok', 'nok');
select sec_to_time(3*60*60 + 12*60 + 30), if (sec_to_time(3*60*60 + 12*60 + 30) = '3:12:30', 'ok', 'nok');
select sec_to_time(24*60*60 - 1), if (sec_to_time(24*60*60 - 1) = '23:59:59', 'ok', 'nok');



-- check if ER_TIME_CONVERSION is occured.
select sec_to_time(-1);
select sec_to_time(24*60*60);

