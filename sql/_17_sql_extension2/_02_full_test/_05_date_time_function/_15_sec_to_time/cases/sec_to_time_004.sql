--exceptional cases when using function as an argument


select sec_to_time(time_to_sec('24:00:00'));
select sec_to_time(time_to_sec(time'23:66:11'));
select sec_to_time(time_to_sec(timestamp'1977-15-23 15:20:44'));
select sec_to_time(time_to_sec(datetime'15:20:44.9899 10/23/1977'));
select sec_to_time(time_to_sec(to_time('aaaaa')));


select sec_to_time(floor(18943373290340298340234234.123456));
select sec_to_time(greatest(100, 1000, 'abcabc'));
select sec_to_time(power(12));
select sec_to_time(round(3678, null));
