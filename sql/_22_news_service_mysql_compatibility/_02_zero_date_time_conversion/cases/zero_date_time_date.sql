--TEST: pass zero date/time values to date function


--TEST: pass zero datetime value
select date(datetime'0000-00-00 00:00:00');
select date(datetime'00/00/0000 00:00:00');
select date(datetime'00:00:00 00/00/0000');
select date(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select date('0000-00-00 00:00:00');
select date('00/00/0000 00:00:00');
select date('00:00:00 00/00/0000');
select date('00:00:00 0000-00-00');
--TEST: pass irregular formats
select date(datetime'0:0:0.0 0/0/0');
select date('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select date(timestamp'0000-00-00 00:00:00');
select date(timestamp'00/00/0000 00:00:00');
select date(timestamp'00:0:00 00/00/0000');
select date(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select date('0000-00-00 00:00:00');
select date('00/00/0000 00:00:00');
select date('00:00:00 00/00/0000');
select date('00:00:00 0000-00-00');
--TEST: pass irregular formats
select date(timestamp'0:0:0 000-0-00');
select date('0:0:0 12/0/00');


--TEST: pass zero date value
select date(date'0000-00-00');
select date(date'00/00/0000');
--TEST: pass string value
select date('0000-00-00');
select date('00/00/0000');
--TEST: pass irregular formats
select date(date'0-0-0');
select date('00/0/000');
