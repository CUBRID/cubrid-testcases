--TEST: pass zero date/time values to date_add function


--TEST: pass zero datetime value
select date_add(datetime'0000-00-00 00:00:00', interval 1500 millisecond);
select date_add('0000-00-00 00:00:00.000', interval 80 second);
--TEST: pass zero datetime value, munus interval value
select date_add(datetime'00/00/0000 00:15:00', interval -15 minute);
select date_add('00/00/0000 9:00:00.0', interval -9 hour);
select date_add(datetime'00:00:00 00/00/0000', interval 5 day);
select date_add('00:00:00 0000-00-00.00', interval -1 week);
select date_add('00-00-00 00:00:00.0000', interval 30 month);
--TEST: pass irregular formats
select date_add(datetime'0-0-0 0:59:0.999', interval '59:00.999' MINUTE_MILLISECOND);


--TEST: pass zero timestamp value
select date_add(timestamp'0000-00-00 00:00:00', interval 2000 year);
select date_add(timestamp'00/00/0000 00:00:00', interval '33.999' SECOND_MILLISECOND);
select date_add(timestamp'00:59:00 00/00/0000', interval -59 minute);
select date_add(timestamp'00:12:30 0000-00-00', interval '12:30' minute_second);
--TEST: pass string value
select date_add('0000-00-00 00:00:00', interval 1 hour);
select date_add('00/00/0000 00:00:00', interval -1 millisecond);
select date_add('13:23:34 00/00/0000', interval '13:23:34' hour_second);
select date_add('00:00:00 0000-00-00', interval 80 hour);
--TEST: pass irregular formats
select date_add(timestamp'0:0:0 000-0-00', interval 2000 second);
select date_add('0:0:0 0/0/00', interval -1 year);


--TEST: pass zero date value
select date_add(date'0000-00-00', interval 1 day);
select date_add(date'00/00/0000', interval 13 month);
--TEST: pass string value
select date_add('0000-00-00', interval -1 year);
select date_add('00/00/0000', interval 1 second);
--TEST: pass irregular formats
select date_add(date'0-0-0', interval 1 day);
select date_add('00/0/000', interval -3 month);
