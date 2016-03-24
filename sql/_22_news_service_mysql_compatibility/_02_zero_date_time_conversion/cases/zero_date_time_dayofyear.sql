--TEST: pass zero date/time values to dayofyear function


--TEST: pass zero datetime value
select dayofyear(datetime'0000-00-00 00:00:00');
select dayofyear(datetime'00/00/0000 00:00:00');
select dayofyear(datetime'00:00:00 00/00/0000');
select dayofyear(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select dayofyear('0000-00-00 00:00:00');
select dayofyear('00/00/0000 00:00:00');
select dayofyear('00:00:00 00/00/0000');
select dayofyear('00:00:00 0000-00-00');
--TEST: pass irregular formats
select dayofyear(datetime'0:0:0.0 0/0/0');
select dayofyear('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select dayofyear(timestamp'0000-00-00 00:00:00');
select dayofyear(timestamp'00/00/0000 00:00:00');
select dayofyear(timestamp'00:0:00 00/00/0000');
select dayofyear(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select dayofyear('0000-00-00 00:00:00');
select dayofyear('00/00/0000 00:00:00');
select dayofyear('00:00:00 00/00/0000');
select dayofyear('00:00:00 0000-00-00');
--TEST: pass irregular formats
select dayofyear(timestamp'0:0:0 000-0-00');
select dayofyear('0:0:0 12/0/00');


--TEST: pass zero date value
select dayofyear(date'0000-00-00');
select dayofyear(date'00/00/0000');
--TEST: pass string value
select dayofyear('0000-00-00');
select dayofyear('00/00/0000');
--TEST: pass irregular formats
select dayofyear(date'0-0-0');
select dayofyear('00/0/000');
