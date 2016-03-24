--TEST: pass zero date/time values to time_to_sec function


--TEST: pass zero datetime value
select time_to_sec(datetime'0000-00-00 00:00:00');
select time_to_sec(datetime'00/00/0000 00:00:00');
select time_to_sec(datetime'00:00:00 00/00/0000');
select time_to_sec(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select time_to_sec('0000-00-00 00:00:00');
select time_to_sec('00/00/0000 00:00:00');
select time_to_sec('00:00:00 00/00/0000');
select time_to_sec('00:00:00 0000-00-00');
--TEST: pass irregular formats
select time_to_sec(datetime'0:0:0.0 0/0/0');
select time_to_sec('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select time_to_sec(timestamp'0000-00-00 00:00:00');
select time_to_sec(timestamp'00/00/0000 00:00:00');
select time_to_sec(timestamp'00:0:00 00/00/0000');
select time_to_sec(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select time_to_sec('0000-00-00 00:00:00');
select time_to_sec('00/00/0000 00:00:00');
select time_to_sec('00:00:00 00/00/0000');
select time_to_sec('00:00:00 0000-00-00');
--TEST: pass irregular formats
select time_to_sec(timestamp'0:0:0 000-0-00');
select time_to_sec('0:0:0 12/0/00');


--TEST: error, pass zero date value
select time_to_sec(date'0000-00-00');
select time_to_sec(date'00/00/0000');
--TEST: error, pass string value
select time_to_sec('0000-00-00');
select time_to_sec('00/00/0000');
--TEST: error, pass irregular formats
select time_to_sec(date'0-0-0');
select time_to_sec('00/0/000');
