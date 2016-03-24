--TEST: pass zero date/time values to adddate function


--TEST: pass zero datetime value
select adddate(datetime'0000-00-00 00:00:00', interval 1500 millisecond);
select adddate('0000-00-00 00:00:00.000', interval 80 second);
--TEST: pass zero datetime value, munus interval value
select adddate(datetime'00/00/0000 00:15:00', interval -15 minute);
select adddate('00/00/0000 9:00:00.0', interval -9 hour);
select adddate(datetime'00:00:00 00/00/0000', interval 5 day);
select adddate('00:00:00 0000-00-00.00', interval -1 week);
select adddate('00-00-00 00:00:00.0000', interval 30 month);
--TEST: pass irregular formats
select adddate(datetime'0-0-0 0:59:0.999', interval '59:00.999' MINUTE_MILLISECOND);


--TEST: pass zero timestamp value
select adddate(timestamp'0000-00-00 00:00:00', interval 2000 year);
select adddate(timestamp'00/00/0000 00:00:00', interval '33.999' SECOND_MILLISECOND);
select adddate(timestamp'00:59:00 00/00/0000', interval -59 minute);
select adddate(timestamp'00:12:30 0000-00-00', interval '12:30' minute_second);
--TEST: pass string value
select adddate('0000-00-00 00:00:00', interval 1 hour);
select adddate('00/00/0000 00:00:00', interval -1 millisecond);
select adddate('13:23:34 00/00/0000', interval '13:23:34' hour_second);
select adddate('00:00:00 0000-00-00', interval 80 hour);
--TEST: pass irregular formats
select adddate(timestamp'0:0:0 000-0-00', interval 2000 second);
select adddate('0:0:0 0/0/00', interval -1 year);


--TEST: pass zero date value
select adddate(date'0000-00-00', interval 1 day);
select adddate(date'00/00/0000', interval 13 month);
--TEST: pass string value
select adddate('0000-00-00', interval -1 year);
select adddate('00/00/0000', interval 1 second);
--TEST: pass irregular formats
select adddate(date'0-0-0', interval 1 day);
select adddate('00/0/000', interval -3 month);
