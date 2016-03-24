--pass different formats of timestampltz/datetimeltz arguments


--1. pass different formats of timestampltz arguments
select month(timestampltz'13:14:55 10/08');

select month(timestampltz'2:22:22 8/12/2010');

select month(timestampltz'09:03:22 PM 1988-08-08');

select month(timestampltz'12/12/2008 10:20:55');



--2. pass different formats of datetimeltz arguments
select month(datetimeltz'13:14:55.123 10/08');

select month(datetimeltz'2:22:22.333 8/12/2010');

select month(datetimeltz'09:03:22.012 PM 1988-08-08');

select month(datetimeltz'12/12/1556 10:20:55.567');
