--+ holdcas on;
--TSET: set return_null_on_function_errors=yes
--TEST: pass zero date/time values to weekday function


set system parameters 'return_null_on_function_errors=yes';

--TEST: pass zero datetime value
select weekday(datetime'0000-00-00 00:00:00');
select weekday(datetime'00/00/0000 00:00:00');
select weekday(datetime'00:00:00 00/00/0000');
select weekday(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select weekday('0000-00-00 00:00:00');
select weekday('00/00/0000 00:00:00');
select weekday('00:00:00 00/00/0000');
select weekday('00:00:00 0000-00-00');
--TEST: pass irregular formats
select weekday(datetime'0:0:0.0 0/0/0');
select weekday('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select weekday(timestamp'0000-00-00 00:00:00');
select weekday(timestamp'00/00/0000 00:00:00');
select weekday(timestamp'00:0:00 00/00/0000');
select weekday(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select weekday('0000-00-00 00:00:00');
select weekday('00/00/0000 00:00:00');
select weekday('00:00:00 00/00/0000');
select weekday('00:00:00 0000-00-00');
--TEST: pass irregular formats
select weekday(timestamp'0:0:0 000-0-00');
select weekday('0:0:0 12/0/00');


--TEST: pass zero date value
select weekday(date'0000-00-00');
select weekday(date'00/00/0000');
--TEST: pass string value
select weekday('0000-00-00');
select weekday('00/00/0000');
--TEST: pass irregular formats
select weekday(date'0-0-0');
select weekday('00/0/000');


set system parameters 'return_null_on_function_errors=no';
commit;
--+ holdcas off;
