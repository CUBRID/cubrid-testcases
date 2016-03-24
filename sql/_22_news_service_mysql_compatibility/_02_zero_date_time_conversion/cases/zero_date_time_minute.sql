--TEST: pass zero date/time values to minute function


--TEST: pass zero datetime value
select minute(datetime'0000-00-00 00:00:00');
select minute(datetime'00/00/0000 00:00:00');
select minute(datetime'00:00:00 00/00/0000');
select minute(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select minute('0000-00-00 00:00:00');
select minute('00/00/0000 00:00:00');
select minute('00:00:00 00/00/0000');
select minute('00:00:00 0000-00-00');
--TEST: pass irregular formats
select minute(datetime'0:0:0.0 0/0/0');
select minute('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select minute(timestamp'0000-00-00 00:00:00');
select minute(timestamp'00/00/0000 00:00:00');
select minute(timestamp'00:0:00 00/00/0000');
select minute(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select minute('0000-00-00 00:00:00');
select minute('00/00/0000 00:00:00');
select minute('00:00:00 00/00/0000');
select minute('00:00:00 0000-00-00');
--TEST: pass irregular formats
select minute(timestamp'0:0:0 000-0-00');
select minute('0:0:0 12/0/00');


--TEST: error, pass zero date value
select minute(date'0000-00-00');
select minute(date'00/00/0000');
--TEST: error, pass string value
select minute('0000-00-00');
select minute('00/00/0000');
--TEST: error, pass irregular formats
select minute(date'0-0-0');
select minute('00/0/000');
