--pass different formats of timestampltz/datetimeltz arguments

--1. pass different formats of timestampltz arguments
select quarter(timestampltz'13:14:55 10/08');

select quarter(timestampltz'2:22:22 8/12/2010');

select quarter(timestampltz'09:03:22 PM 1988-08-08');

select quarter(timestampltz'12/12/1988 10:20:55');


--2. pass different formats of datetimeltz arguments
select quarter(datetimeltz'13:14:55.123 10/08');

select quarter(datetimeltz'2:22:22.333 8/12/2010');

select quarter(datetimeltz'09:03:22.012 PM 1988-08-08');

select quarter(datetimeltz'12/12/1556 10:20:55.567');


