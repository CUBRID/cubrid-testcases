--TEST: pass zero date/time values to to_days function


--TEST: pass zero datetime value
select to_days(datetime'0000-00-00 00:00:00');
select to_days(datetime'00/00/0000 00:00:00');
select to_days(datetime'00:00:00 00/00/0000');
select to_days(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select to_days('0000-00-00 00:00:00');
select to_days('00/00/0000 00:00:00');
select to_days('00:00:00 00/00/0000');
select to_days('00:00:00 0000-00-00');
--TEST: pass irregular formats
select to_days(datetime'0:0:0.0 0/0/0');
select to_days('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select to_days(timestamp'0000-00-00 00:00:00');
select to_days(timestamp'00/00/0000 00:00:00');
select to_days(timestamp'00:0:00 00/00/0000');
select to_days(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select to_days('0000-00-00 00:00:00');
select to_days('00/00/0000 00:00:00');
select to_days('00:00:00 00/00/0000');
select to_days('00:00:00 0000-00-00');
--TEST: pass irregular formats
select to_days(timestamp'0:0:0 000-0-00');
select to_days('0:0:0 12/0/00');


--TEST: pass zero date value
select to_days(date'0000-00-00');
select to_days(date'00/00/0000');
--TEST: pass string value
select to_days('0000-00-00');
select to_days('00/00/0000');
--TEST: pass irregular formats
select to_days(date'0-0-0');
select to_days('00/0/000');
