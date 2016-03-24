--exceptional cases when using function as an argument


select from_days(to_days('10000-12-12'));
select from_days(to_days(date'01/33/0001'));
select from_days(to_days(timestamp'abc'));
select from_days(to_days(to_datetime('12:30:12:222')));
select from_days(to_days(from_days(to_days(to_datetime('1999-10-39 12:30:12:222')))));


select from_days(floor('abc'));
select from_days(round(43443, 'ddd'));
select from_days(least(888, 3456, time'12:22:23'));
select from_days(power(7, 383838888));

