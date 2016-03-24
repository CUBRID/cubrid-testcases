--TEST: pass zero date/time values to day function


--TEST: pass zero datetime value
select day(datetime'0000-00-00 00:00:00');
select day(datetime'00/00/0000 00:00:00');
select day(datetime'00:00:00 00/00/0000');
select day(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select day('0000-00-00 00:00:00');
select day('00/00/0000 00:00:00');
select day('00:00:00 00/00/0000');
select day('00:00:00 0000-00-00');
--TEST: pass irregular formats
select day(datetime'0:0:0.0 0/0/0');
select day('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select day(timestamp'0000-00-00 00:00:00');
select day(timestamp'00/00/0000 00:00:00');
select day(timestamp'00:0:00 00/00/0000');
select day(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select day('0000-00-00 00:00:00');
select day('00/00/0000 00:00:00');
select day('00:00:00 00/00/0000');
select day('00:00:00 0000-00-00');
--TEST: pass irregular formats
select day(timestamp'0:0:0 000-0-00');
select day('0:0:0 12/0/00');


--TEST: pass zero date value
select day(date'0000-00-00');
select day(date'00/00/0000');
--TEST: pass string value
select day('0000-00-00');
select day('00/00/0000');
--TEST: pass irregular formats
select day(date'0-0-0');
select day('00/0/000');
select day('00/0/00');
