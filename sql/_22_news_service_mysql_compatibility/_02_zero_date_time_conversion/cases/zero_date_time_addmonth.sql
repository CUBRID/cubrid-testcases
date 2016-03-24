--TEST: pass zero date/time values to add_months function


--TEST: pass zero datetime value
select add_months(datetime'0000-00-00 00:00:00', 1);
select add_months('0000-00-00 00:00:00.000', -1);
--TEST: pass zero datetime value, munus interval value
select add_months(datetime'00/00/0000 00:15:00', 15);
select add_months('00/00/0000 9:00:00.0', -9);
select add_months(datetime'00:00:00 00/00/0000', 13);
select add_months('00:00:00 0000-00-00.00', 32);
select add_months('00-00-00 00:00:00.0000', 6);
--TEST: pass irregular formats
select add_months(datetime'0-0-0 0:59:0.999', -0.5);


--TEST: pass zero timestamp value
select add_months(timestamp'0000-00-00 00:00:00', 1);
select add_months(timestamp'00/00/0000 00:00:00', 2);
select add_months(timestamp'00:0:00 00/00/0000', 3);
select add_months(timestamp'00:00:00 0000-00-00', 4);
--TEST: pass string value
select add_months('0000-00-00 00:00:00', -1);
select add_months('00/00/0000 00:00:00', 32);
select add_months('00:00:00 00/00/0000', 33);
select add_months('00:00:00 0000-00-00', 55);
--TEST: pass irregular formats
select add_months(timestamp'0:0:0 000-0-00', 4);
select add_months('0:0:0 12/0/00', 12);


--TEST: pass zero date value
select add_months(date'0000-00-00', 5);
select add_months(date'00/00/0000', 99);
--TEST: pass string value
select add_months('0000-00-00', 34);
select add_months('00/00/0000', -3);
--TEST: pass irregular formats
select add_months(date'0-0-0', 31);
select add_months('00/0/000', 12);
