--TEST: pass zero date/time values to to_char function


--TEST: pass zero datetime value
select to_char(datetime'0000-00-00 00:00:00');
select to_char(datetime'00/00/0000 00:00:00');
select to_char(datetime'00:00:00 00/00/0000');
select to_char(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select to_char('0000-00-00 00:00:00');
select to_char('00/00/0000 00:00:00');
select to_char('00:00:00 00/00/0000');
select to_char('00:00:00 0000-00-00');
--TEST: pass irregular formats
select to_char(datetime'0:0:0.0 0/0/0');
select to_char('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select to_char(timestamp'0000-00-00 00:00:00');
select to_char(timestamp'00/00/0000 00:00:00');
select to_char(timestamp'00:0:00 00/00/0000');
select to_char(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select to_char('0000-00-00 00:00:00');
select to_char('00/00/0000 00:00:00');
select to_char('00:00:00 00/00/0000');
select to_char('00:00:00 0000-00-00');
--TEST: pass irregular formats
select to_char(timestamp'0:0:0 000-0-00');
select to_char('0:0:0 12/0/00');


--TEST: pass zero date value
select to_char(date'0000-00-00');
select to_char(date'00/00/0000');
--TEST: pass string value
select to_char('0000-00-00');
select to_char('00/00/0000');
--TEST: pass irregular formats
select to_char(date'0-0-0');
select to_char('00/0/000');
