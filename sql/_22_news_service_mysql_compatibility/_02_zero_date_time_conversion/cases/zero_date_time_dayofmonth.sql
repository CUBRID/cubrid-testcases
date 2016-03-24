--TEST: pass zero date/time values to dayofmonth function


--TEST: pass zero datetime value
select dayofmonth(datetime'0000-00-00 00:00:00');
select dayofmonth(datetime'00/00/0000 00:00:00');
select dayofmonth(datetime'00:00:00 00/00/0000');
select dayofmonth(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select dayofmonth('0000-00-00 00:00:00');
select dayofmonth('00/00/0000 00:00:00');
select dayofmonth('00:00:00 00/00/0000');
select dayofmonth('00:00:00 0000-00-00');
--TEST: pass irregular formats
select dayofmonth(datetime'0:0:0.0 0/0/0');
select dayofmonth('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select dayofmonth(timestamp'0000-00-00 00:00:00');
select dayofmonth(timestamp'00/00/0000 00:00:00');
select dayofmonth(timestamp'00:0:00 00/00/0000');
select dayofmonth(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select dayofmonth('0000-00-00 00:00:00');
select dayofmonth('00/00/0000 00:00:00');
select dayofmonth('00:00:00 00/00/0000');
select dayofmonth('00:00:00 0000-00-00');
--TEST: pass irregular formats
select dayofmonth(timestamp'0:0:0 000-0-00');
select dayofmonth('0:0:0 12/0/00');


--TEST: pass zero date value
select dayofmonth(date'0000-00-00');
select dayofmonth(date'00/00/0000');
--TEST: pass string value
select dayofmonth('0000-00-00');
select dayofmonth('00/00/0000');
--TEST: pass irregular formats
select dayofmonth(date'0-0-0');
select dayofmonth('00/0/000');
