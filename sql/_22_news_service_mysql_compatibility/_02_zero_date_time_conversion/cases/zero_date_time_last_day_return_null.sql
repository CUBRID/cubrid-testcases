--+ holdcas on;
--TSET: set return_null_on_function_errors=yes
--TEST: pass zero date/time values to last_day function


set system parameters 'return_null_on_function_errors=yes';

--TEST: error, pass zero datetime value
select last_day(datetime'0000-00-00 00:00:00');
--TEST: pass zero datetime value with cast func
select last_day(cast(datetime'00/00/0000 00:00:00' as date));
select last_day(cast(datetime'00:00:00 00/00/0000' as date));
select last_day(cast(datetime'00:00:00 0000-00-00' as date));
--TEST: pass string value
select last_day(cast('0000-00-00 00:00:00' as date));
select last_day(cast('00/00/0000 00:00:00' as date));
select last_day(cast('00:00:00 00/00/0000' as date));
select last_day(cast('00:00:00 0000-00-00' as date));
--TEST: pass irregular formats
select last_day(cast(datetime'0:0:0.0 0/0/0' as date));
select last_day(cast('0:00:0.0 000-0-00' as date));


--TEST: error, pass zero timestamp value
select last_day(cast(timestamp'0000-00-00 00:00:00' as date));
--TEST: pass zero timestamp value with cast func
select last_day(cast(timestamp'00/00/0000 00:00:00' as date));
select last_day(cast(timestamp'00:0:00 00/00/0000' as date));
select last_day(cast(timestamp'00:00:00 0000-00-00' as date));
--TEST: pass string value
select last_day(cast('0000-00-00 00:00:00' as date));
select last_day(cast('00/00/0000 00:00:00' as date));
select last_day(cast('00:00:00 00/00/0000' as date));
select last_day(cast('00:00:00 0000-00-00' as date));
--TEST: pass irregular formats
select last_day(cast(timestamp'0:0:0 000-0-00' as date));
select last_day(cast('0:0:0 12/0/00' as date));


--TEST: pass zero last_day value
select last_day(date'0000-00-00');
select last_day(date'00/00/0000');
--TEST: pass string value
select last_day('0000-00-00');
select last_day('00/00/0000');
--TEST: pass irregular formats
select last_day(date'0-0-0');
select last_day('00/0/000');


set system parameters 'return_null_on_function_errors=no';
commit;
--+ holdcas off;
