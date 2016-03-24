--use function as an argument


select sec_to_time(time_to_sec('15:20:44'));
select sec_to_time(time_to_sec(time'15:20:44'));
select sec_to_time(time_to_sec(timestamp'1977-10-23 15:20:44'));
select sec_to_time(time_to_sec(datetime'15:20:44.123 10/23/1977'));
select sec_to_time(time_to_sec(to_time('15:20:44')));
select sec_to_time(time_to_sec(sec_to_time(time_to_sec(to_time('15:20:44')))));


select sec_to_time(floor(189433.123456));
select sec_to_time(greatest(100, 1000, 10000));
select sec_to_time(power(4, 5));
select sec_to_time(round(3678, 2));
select sec_to_time(if(1*5=5, time_to_sec('1:1:1'), 3455555));


--expression as an argument
select sec_to_time(25*3/8+29282);
