--TEST: pass zero date/time values to extract function


--TEST: pass zero datetime value
select extract(millisecond from datetime'0000-00-00 00:00:00');
select extract(millisecond from datetime'00/00/0000 00:00:00');
select extract(second from datetime'00:00:00 00/00/0000');
select extract(second from datetime'00:00:00 0000-00-00');
--TEST: pass string value
select extract(minute from '0000-00-00 00:00:00');
select extract(minute from '00/00/0000 00:00:00');
select extract(hour from '00:00:00 00/00/0000');
select extract(day from '00:00:00 0000-00-00');
--TEST: pass irregular formats
select extract(millisecond from datetime'0:0:0.0 0/0/0');
select extract(year from '0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select extract(minute from timestamp'0000-00-00 00:00:00');
select extract(millisecond from timestamp'00/00/0000 00:00:00');
select extract(second from timestamp'00:0:00 00/00/0000');
select extract(hour from timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select extract(day from '0000-00-00 00:00:00');
select extract(month from '00/00/0000 00:00:00');
select extract(year from '00:00:00 00/00/0000');
select extract(second from '00:00:00 0000-00-00');
--TEST: pass irregular formats
select extract(minute from timestamp'0:0:0 000-0-00');
select extract(hour from '0:0:0 12/0/00');


--TEST: pass zero extract value
select extract(hour from date'0000-00-00');
select extract(day from date'00/00/0000');
--TEST: pass string value
select extract(month from '0000-00-00');
select extract(year from '00/00/0000');
--TEST: pass irregular formats
select extract(day from date'0-0-0');
select extract(month from '00/0/000');
