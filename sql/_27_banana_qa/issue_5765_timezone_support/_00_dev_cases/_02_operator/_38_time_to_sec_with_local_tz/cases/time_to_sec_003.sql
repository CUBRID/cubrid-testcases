-- pass different formats of timestampltz/datetimeltz arguments

set timezone '+9:00';

--2. pass different formats of timestampltz arguments
select time_to_sec(timestampltz'2010-10-08 2:16:10');

select time_to_sec(timestampltz'2009-1-09 4:30:01 am');

select time_to_sec(timestampltz'1999-11-30 9:10:10 pm');

select time_to_sec(timestampltz'13:14:55 10/08');

select time_to_sec(timestampltz'2:22:22 8/12/2010');

select time_to_sec(timestampltz'09:03:22 PM 1988-08-08');

select time_to_sec(timestampltz'12/12/1999 10:20:55');



--3. pass different formats of datetimeltz arguments
select time_to_sec(datetimeltz'13:14:55.123 10/08');

select time_to_sec(datetimeltz'2:22:22.333 8/12/2010');

select time_to_sec(datetimeltz'09:03:22.012 PM 1988-08-08');

select time_to_sec(datetimeltz'12/12/1644 10:20:55.789');

set timezone 'Asia/Seoul';
