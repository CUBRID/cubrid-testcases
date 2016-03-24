--use function as an argument



select from_days(to_days('1878-12-12'));
select from_days(to_days(date'01/01/0001'));
select from_days(to_days(timestamp'9999-12-31 20:12:34'));
select from_days(to_days(to_datetime('10000-03-15 12:30:12:222')));
select from_days(to_days(from_days(to_days(to_datetime('1999-10-10 12:30:12:222')))));


select from_days(floor(13579.27283));
select from_days(round(43443, 2));
select from_days(least(888, 3456, 22234));
select from_days(power(7, 6));


select from_days(to_days('1-1-1'));

select from_days(to_days('0200-2-29'));

select from_days(to_days('0200-3-1'));
