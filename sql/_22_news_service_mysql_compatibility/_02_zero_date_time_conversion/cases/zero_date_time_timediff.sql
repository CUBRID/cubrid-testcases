--TEST: pass zero date/time values to timediff function


--TEST: error, 2 arguments with different types
select timediff(datetime'0000-00-00 00:00:00', timestamp'00/00/0000 00:00:00');
select timediff(datetime'00/00/0000 00:00:00', '00:00:00 00/00/0000');
--TEST: 2 arguments with same type
select timediff(datetime'00:00:00 00/00/0000', datetime'00:00:00 00/00/0000');
select timediff(datetime'00:00:00 0000-00-00', datetime'00/00/0000 00:00:00');
--TEST: pass string value
select timediff('0000-00-00 12:12:12', '0000-00-00 00:00:00');
select timediff('00/00/0000 00:00:00', '0000-00-00 12:12:12');
select timediff('00:00:00 00/00/0000', datetime'00/00/0000 00:00:00');
select timediff('00:00:00 0000-00-00', timestamp'00:0:00 00/00/0000');
--TEST: pass irregular formats
select timediff(datetime'0001-01-01 01:01:01', datetime'0:0:0.0 0/0/0');
select timediff('0:00:0.0 000-0-00', date'0000-00-00');


--TEST: pass zero timestamp value
select timediff(timestamp'0000-00-00 00:00:00', timestamp'0000-00-00 00:00:00');
select timediff(timestamp'00/00/0000 00:00:00', '00:00:00 0000-00-00');
select timediff(timestamp'00:0:00 00/00/0000', date'00/00/0000');
select timediff('12:12:12', timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select timediff('12:12:12', '0000-00-00 00:00:00');
select timediff('00/00/0000 00:00:00', '12:12:12');
select timediff('00:00:00 00/00/0000', datetime'00:00:00 0000-00-00');
select timediff('00:00:00 0000-00-00', '00:00:00 0000-00-00');
--TEST: pass irregular formats
select timediff(timestamp'12:12:12', timestamp'0:0:0 000-0-00');
select timediff('0:0:0 00/0/00', '00:00:00 0000-00-00');


--TEST: error, pass zero date value
select timediff(date'0000-00-00', date'1-1-1');
select timediff(date'00/00/0000', '0000-00-00');
--TEST: error, pass string value
select timediff('0000-00-00', '00/00/0000');
select timediff('00/00/0000', date'1-1-1');
--TEST: error, pass irregular formats
select timediff(date'0-0-0', datetime'00:00:00 0000-00-00');
select timediff('00/0/000', '12:12:12');
