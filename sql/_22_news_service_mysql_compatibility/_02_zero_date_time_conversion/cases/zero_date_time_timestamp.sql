--TEST: pass zero date/time values to timestamp function


--TEST: pass zero datetime value
select timestamp(datetime'0000-00-00 00:00:00');
select timestamp(datetime'00/00/0000 00:00:00');
select timestamp(datetime'00:00:00 00/00/0000');
select timestamp(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select timestamp('0000-00-00 00:00:00');
select timestamp('00/00/0000 00:00:00');
select timestamp('00:00:00 00/00/0000');
select timestamp('00:00:00 0000-00-00');
--TEST: pass irregular formats
select timestamp(datetime'0:0:0.0 0/0/0');
select timestamp('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select timestamp(timestamp'0000-00-00 00:00:00');
select timestamp(timestamp'00/00/0000 00:00:00');
select timestamp(timestamp'00:0:00 00/00/0000');
select timestamp(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select timestamp('0000-00-00 00:00:00');
select timestamp('00/00/0000 00:00:00');
select timestamp('00:00:00 00/00/0000');
select timestamp('00:00:00 0000-00-00');
--TEST: pass irregular formats
select timestamp(timestamp'0:0:0 000-0-00');
select timestamp('0:0:0 12/0/00');


--TEST: pass zero date value
select timestamp(date'0000-00-00');
select timestamp(date'00/00/0000');
--TEST: pass string value
select timestamp('0000-00-00');
select timestamp('00/00/0000');
--TEST: pass irregular formats
select timestamp(date'0-0-0');
select timestamp('00/0/000');
