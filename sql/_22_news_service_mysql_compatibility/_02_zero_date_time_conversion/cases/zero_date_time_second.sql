--TEST: pass zero date/time values to second function


--TEST: pass zero datetime value
select second(datetime'0000-00-00 00:00:00');
select second(datetime'00/00/0000 00:00:00');
select second(datetime'00:00:00 00/00/0000');
select second(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select second('0000-00-00 00:00:00');
select second('00/00/0000 00:00:00');
select second('00:00:00 00/00/0000');
select second('00:00:00 0000-00-00');
--TEST: pass irregular formats
select second(datetime'0:0:0.0 0/0/0');
select second('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select second(timestamp'0000-00-00 00:00:00');
select second(timestamp'00/00/0000 00:00:00');
select second(timestamp'00:0:00 00/00/0000');
select second(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select second('0000-00-00 00:00:00');
select second('00/00/0000 00:00:00');
select second('00:00:00 00/00/0000');
select second('00:00:00 0000-00-00');
--TEST: pass irregular formats
select second(timestamp'0:0:0 000-0-00');
select second('0:0:0 12/0/00');


--TEST: error, pass zero date value
select second(date'0000-00-00');
select second(date'00/00/0000');
--TEST: error, pass string value
select second('0000-00-00');
select second('00/00/0000');
--TEST: error, pass irregular formats
select second(date'0-0-0');
select second('00/0/000');
