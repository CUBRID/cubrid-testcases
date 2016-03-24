--TEST: pass zero date/time values to quarter function


--TEST: pass zero datetime value
select quarter(datetime'0000-00-00 00:00:00');
select quarter(datetime'00/00/0000 00:00:00');
select quarter(datetime'00:00:00 00/00/0000');
select quarter(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select quarter('0000-00-00 00:00:00');
select quarter('00/00/0000 00:00:00');
select quarter('00:00:00 00/00/0000');
select quarter('00:00:00 0000-00-00');
--TEST: pass irregular formats
select quarter(datetime'0:0:0.0 0/0/0');
select quarter('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select quarter(timestamp'0000-00-00 00:00:00');
select quarter(timestamp'00/00/0000 00:00:00');
select quarter(timestamp'00:0:00 00/00/0000');
select quarter(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select quarter('0000-00-00 00:00:00');
select quarter('00/00/0000 00:00:00');
select quarter('00:00:00 00/00/0000');
select quarter('00:00:00 0000-00-00');
--TEST: pass irregular formats
select quarter(timestamp'0:0:0 000-0-00');
select quarter('0:0:0 12/0/00');


--TEST: pass zero date value
select quarter(date'0000-00-00');
select quarter(date'00/00/0000');
--TEST: pass string value
select quarter('0000-00-00');
select quarter('00/00/0000');
--TEST: pass irregular formats
select quarter(date'0-0-0');
select quarter('00/0/000');
