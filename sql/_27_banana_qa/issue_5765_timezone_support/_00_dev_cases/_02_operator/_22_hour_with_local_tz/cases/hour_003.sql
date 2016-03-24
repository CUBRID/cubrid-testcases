-- pass different formats of timeltz/timestampltz/datetimeltz arguments

set timezone '+9:00';


--2. pass different formats of  arguments
select hour(timestampltz'2010-10-08 2:16:10');

select hour(timestampltz'2009-1-09 4:30:01 am');

select hour(timestampltz'1999-11-30 9:10:10 pm');

select hour(timestampltz'13:14:55 10/08');

select hour(timestampltz'2:22:22 8/12/2010');

select hour(timestampltz'09:03:22 PM 1988-08-08');

select hour(timestampltz'12/12/1999 10:20:55');



--3. pass different formats of datetimeltz arguments
select hour(datetimeltz'13:14:55.123 10/08');

select hour(datetimeltz'2:22:22.333 8/12/2010');

select hour(datetimeltz'09:03:22.012 PM 1988-08-08');

select hour(datetimeltz'12/12/1644 10:20:55.789');

set timezone 'Asia/Seoul';
