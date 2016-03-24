--TEST: pass zero date/time values to year function


--TEST: pass zero datetime value
select year(datetime'0000-00-00 00:00:00');
select year(datetime'00/00/0000 00:00:00');
select year(datetime'00:00:00 00/00/0000');
select year(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select year('0000-00-00 00:00:00');
select year('00/00/0000 00:00:00');
select year('00:00:00 00/00/0000');
select year('00:00:00 0000-00-00');
--TEST: pass irregular formats
select year(datetime'0:0:0.0 0/0/0');
select year('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select year(timestamp'0000-00-00 00:00:00');
select year(timestamp'00/00/0000 00:00:00');
select year(timestamp'00:0:00 00/00/0000');
select year(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select year('0000-00-00 00:00:00');
select year('00/00/0000 00:00:00');
select year('00:00:00 00/00/0000');
select year('00:00:00 0000-00-00');
--TEST: pass irregular formats
select year(timestamp'0:0:0 000-0-00');
select year('0:0:0 12/0/00');


--TEST: pass zero date value
select year(date'0000-00-00');
select year(date'00/00/0000');
--TEST: pass string value
select year('0000-00-00');
select year('00/00/0000');
--TEST: pass irregular formats
select year(date'0-0-0');
select year('00/0/000');
