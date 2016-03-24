--TEST: pass zero date/time values to month function


--TEST: pass zero datetime value
select month(datetime'0000-00-00 00:00:00');
select month(datetime'00/00/0000 00:00:00');
select month(datetime'00:00:00 00/00/0000');
select month(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select month('0000-00-00 00:00:00');
select month('00/00/0000 00:00:00');
select month('00:00:00 00/00/0000');
select month('00:00:00 0000-00-00');
--TEST: pass irregular formats
select month(datetime'0:0:0.0 0/0/0');
select month('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select month(timestamp'0000-00-00 00:00:00');
select month(timestamp'00/00/0000 00:00:00');
select month(timestamp'00:0:00 00/00/0000');
select month(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select month('0000-00-00 00:00:00');
select month('00/00/0000 00:00:00');
select month('00:00:00 00/00/0000');
select month('00:00:00 0000-00-00');
--TEST: pass irregular formats
select month(timestamp'0:0:0 000-0-00');
select month('0:0:0 12/0/00');


--TEST: pass zero date value
select month(date'0000-00-00');
select month(date'00/00/0000');
--TEST: pass string value
select month('0000-00-00');
select month('00/00/0000');
--TEST: pass irregular formats
select month(date'0-0-0');
select month('00/0/000');
