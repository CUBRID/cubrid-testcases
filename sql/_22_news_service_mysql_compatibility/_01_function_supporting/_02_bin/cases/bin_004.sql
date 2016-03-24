--TEST: exceptional cases when using function as an argument


--TEST: invalid params for to_days function
select bin(to_days('10000-12-12'));
select bin(to_days(date'01/33/0001'));
select bin(to_days(timestamp'abc'));
select bin(to_days(addtime('12:30:12:222', '13:13:12')));
select bin(to_days(from_days(to_days(adddate('1999-10-39 12:30:12:222', 123)))));


--TEST: invalid params for numeric functions
select bin(floor('abc'));
select bin(round(43443, 'ddd'));
select bin(least(888, 3456, time'12:22:23'));
select bin(power(7, 383838888));
select bin(truncate(time'12:12:12', 3));

