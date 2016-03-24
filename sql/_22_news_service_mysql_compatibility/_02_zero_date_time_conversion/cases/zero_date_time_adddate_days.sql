--TEST: pass zero date/time values to adddate function


--TEST: pass zero datetime value
select adddate(datetime'0000-00-00 00:00:00', 1);
select adddate('0000-00-00 00:00:00.000', -1);
--TEST: pass zero datetime value, munus interval value
select adddate(datetime'00/00/0000 00:15:00', 15);
select adddate('00/00/0000 9:00:00.0', -9);
select adddate(datetime'00:00:00 00/00/0000', 13);
select adddate('00:00:00 0000-00-00.00', 32);
select adddate('00-00-00 00:00:00.0000', 6);
--TEST: pass irregular formats
select adddate(datetime'0-0-0 0:59:0.999', -0.5);


--TEST: pass zero timestamp value
select adddate(timestamp'0000-00-00 00:00:00', 1);
select adddate(timestamp'00/00/0000 00:00:00', 2);
select adddate(timestamp'00:0:00 00/00/0000', 3);
select adddate(timestamp'00:00:00 0000-00-00', 4);
--TEST: pass string value
select adddate('0000-00-00 00:00:00', -1);
select adddate('00/00/0000 00:00:00', 32);
select adddate('00:00:00 00/00/0000', 33);
select adddate('00:00:00 0000-00-00', 55);
--TEST: pass irregular formats
select adddate(timestamp'0:0:0 000-0-00', 4);
select adddate('0:0:0 12/0/00', 12);


--TEST: pass zero date value
select adddate(date'0000-00-00', 5);
select adddate(date'00/00/0000', 99);
--TEST: pass string value
select adddate('0000-00-00', 34);
select adddate('00/00/0000', -3);
--TEST: pass irregular formats
select adddate(date'0-0-0', 31);
select adddate('00/0/000', 12);
