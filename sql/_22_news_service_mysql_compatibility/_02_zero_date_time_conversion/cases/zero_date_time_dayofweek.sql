--TEST: pass zero date/time values to dayofweek function


--TEST: pass zero datetime value
select dayofweek(datetime'0000-00-00 00:00:00');
select dayofweek(datetime'00/00/0000 00:00:00');
select dayofweek(datetime'00:00:00 00/00/0000');
select dayofweek(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select dayofweek('0000-00-00 00:00:00');
select dayofweek('00/00/0000 00:00:00');
select dayofweek('00:00:00 00/00/0000');
select dayofweek('00:00:00 0000-00-00');
--TEST: pass irregular formats
select dayofweek(datetime'0:0:0.0 0/0/0');
select dayofweek('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select dayofweek(timestamp'0000-00-00 00:00:00');
select dayofweek(timestamp'00/00/0000 00:00:00');
select dayofweek(timestamp'00:0:00 00/00/0000');
select dayofweek(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select dayofweek('0000-00-00 00:00:00');
select dayofweek('00/00/0000 00:00:00');
select dayofweek('00:00:00 00/00/0000');
select dayofweek('00:00:00 0000-00-00');
--TEST: pass irregular formats
select dayofweek(timestamp'0:0:0 000-0-00');
select dayofweek('0:0:0 12/0/00');


--TEST: pass zero date value
select dayofweek(date'0000-00-00');
select dayofweek(date'00/00/0000');
--TEST: pass string value
select dayofweek('0000-00-00');
select dayofweek('00/00/0000');
--TEST: pass irregular formats
select dayofweek(date'0-0-0');
select dayofweek('00/0/000');
