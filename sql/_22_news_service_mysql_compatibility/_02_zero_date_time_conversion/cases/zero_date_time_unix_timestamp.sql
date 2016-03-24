--TEST: pass zero date/time values to unix_timestamp function


--TEST: pass zero datetime value
select unix_timestamp(datetime'0000-00-00 00:00:00');
select unix_timestamp(datetime'00/00/0000 00:00:00');
select unix_timestamp(datetime'00:00:00 00/00/0000');
select unix_timestamp(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select unix_timestamp('0000-00-00 00:00:00');
select unix_timestamp('00/00/0000 00:00:00');
select unix_timestamp('00:00:00 00/00/0000');
select unix_timestamp('00:00:00 0000-00-00');
--TEST: pass irregular formats
select unix_timestamp(datetime'0:0:0.0 0/0/0');
select unix_timestamp('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select unix_timestamp(timestamp'0000-00-00 00:00:00');
select unix_timestamp(timestamp'00/00/0000 00:00:00');
select unix_timestamp(timestamp'00:0:00 00/00/0000');
select unix_timestamp(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select unix_timestamp('0000-00-00 00:00:00');
select unix_timestamp('00/00/0000 00:00:00');
select unix_timestamp('00:00:00 00/00/0000');
select unix_timestamp('00:00:00 0000-00-00');
--TEST: pass irregular formats
select unix_timestamp(timestamp'0:0:0 000-0-00');
select unix_timestamp('0:0:0 12/0/00');


--TEST: pass zero date value
select unix_timestamp(date'0000-00-00');
select unix_timestamp(date'00/00/0000');
--TEST: pass string value
select unix_timestamp('0000-00-00');
select unix_timestamp('00/00/0000');
--TEST: pass irregular formats
select unix_timestamp(date'0-0-0');
select unix_timestamp('00/0/000');
