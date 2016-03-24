-- pass different formats of timestampltz/datetimeltz arguments


set timezone '+9:00';

--2. pass different formats of timestampltz arguments
select date(timestampltz'2010-10-08 2:16:10');

select date(timestampltz'2009-1-09 4:30:01 am');

select date(timestampltz'1999-11-30 9:10:10 pm');

select date(timestampltz'13:14:55 10/08/2014');

select date(timestampltz'2:22:22 8/12/2010');

select date(timestampltz'09:03:22 PM 1988-08-08');

select date(timestampltz'12/12/1999 10:20:55');

--error
select date(timestampltz'12/12/1999 18:20:55 AM');



--3. pass different formats of datetimeltz arguments
select date(datetimeltz'13:14:55.123 10/08/2014');

select date(datetimeltz'2:22:22.333 8/12/2010');

select date(datetimeltz'09:03:22.012 PM 1988-08-08');

select date(datetimeltz'12/12/1644 10:20:55.789');

--error
select date(datetimeltz'12/12/1644 21:20:55.789 am');

set timezone 'Asia/Seoul';
