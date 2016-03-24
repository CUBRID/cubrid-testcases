--+ holdcas on;
--TSET: set return_null_on_function_errors=yes
--TEST: pass zero date/time values to week function


set system parameters 'return_null_on_function_errors=yes';

--TEST: pass zero datetime value
select week(datetime'0000-00-00 00:00:00');
select week(datetime'00/00/0000 00:00:00');
select week(datetime'00:00:00 00/00/0000');
select week(datetime'00:00:00 0000-00-00');
--TEST: pass string value
select week('0000-00-00 00:00:00');
select week('00/00/0000 00:00:00');
select week('00:00:00 00/00/0000');
select week('00:00:00 0000-00-00');
--TEST: pass irregular formats
select week(datetime'0:0:0.0 0/0/0');
select week('0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select week(timestamp'0000-00-00 00:00:00');
select week(timestamp'00/00/0000 00:00:00');
select week(timestamp'00:0:00 00/00/0000');
select week(timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select week('0000-00-00 00:00:00');
select week('00/00/0000 00:00:00');
select week('00:00:00 00/00/0000');
select week('00:00:00 0000-00-00');
--TEST: pass irregular formats
select week(timestamp'0:0:0 000-0-00');
select week('0:0:0 12/0/00');


--TEST: pass zero date value
select week(date'0000-00-00');
select week(date'00/00/0000');
--TEST: pass string value
select week('0000-00-00');
select week('00/00/0000');
--TEST: pass irregular formats
select week(date'0-0-0');
select week('00/0/000');


set system parameters 'return_null_on_function_errors=no';
commit;
--+ holdcas off;
