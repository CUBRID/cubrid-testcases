--Pop error. When the time is more than 24 hours.
select timediff(to_date('2012-12-2'),to_date('2011-12-2'));

--Pop error. When the two parameter isn't identical.
select timediff (date'2010-01-01', timestamp'1990-01-01 03:04:05');
select timediff (datetime'2010-01-01 09:08:07', date'2010-01-01');
select timediff (time'12:00:00', datetime'2010-01-01 12:00:00');
select timediff(time'12:00:00', datetime'2010-01-01 03:04:05');
select timediff(time'1:1:2', timestamp'2011-03-07 1:1:1');
select timediff(time'11:59:58 pm', datetime'03/09/1998 11:59:58 pm');
select timediff(timestamp'1999-10-10 18:14:45', date'1999-10-10');
select timediff(date'0-0-0', datetime'00:00:00 0000-00-00');
select timediff(timestamp'00:0:00 00/00/0000', date'00/00/0000');

select timediff(time'12:00:00','2011-01-01');
select timediff(time'12:00:00',date'2011-01-01');

--Datetime and timestamp is same.
select timediff (datetime'2010-01-01 09:08:07', timestamp'2010-01-01 03:04:05');

--When the first parameter is smaller than the second, it will pop error.
select timediff (datetime'2012-02-01 08:00:01', datetime'2012-02-01 08:02:03');
select timediff (datetime'2012-02-01 09:00:01', datetime'2012-02-01 08:02:03');
select timediff (datetime'2012-02-01 09:00:01', datetime'2012-02-01 09:02:03');
select timediff (datetime'2012-02-01 01:00:01', datetime'2012-02-01 08:02:03');
select timediff('0000-00-00 00:00:00', '00/00/0000 01:02:03');
select timediff(datetime'0000-00-00 00:00:00', datetime'00/00/0000 01:02:03');

--q3
SELECT TIMEDIFF(time '09:18:19', time '09:05:52');
SELECT TIMEDIFF(time '09:13:12', time '10:06:12');

