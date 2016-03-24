--cases from dev

-- test for valid date time with ltz format
select dayofweek(datetimeltz'2003-08-23 01:02:03.1234'), if (dayofweek(datetimeltz'2010-08-23 01:02:03.1234') = 2, 'ok', 'nok');
select dayofweek(timestampltz'2010-08-23 01:02:03'), if (dayofweek(timestampltz'2010-08-23 01:02:03') = 2, 'ok', 'nok');



