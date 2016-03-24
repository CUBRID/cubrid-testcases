--+ holdcas on;
--TSET: set return_null_on_function_errors=yes
--TEST: pass zero date/time values to datediff function


set system parameters 'return_null_on_function_errors=yes';

--TEST: pass zero datedifftime value
select datediff(datetime'0000-00-00 00:00:00', '2011-11-3');
select datediff(datetime'00/00/0000 00:00:00', '0000-00-00 00:00:00');
select datediff(datetime'00:00:00 00/00/0000', timestamp'1999-09-09 12:12:12');
select datediff(datetime'00:00:00 0000-00-00', '0000-00-00');
--TEST: pass string value
select datediff(date'0001-01-01', '0000-00-00 00:00:00');
select datediff(datetime'00/00/0000 00:00:00', '00/00/0000 00:00:00');
select datediff('11/11/1989', '00:00:00 00/00/0000');
select datediff('12:13:14.999 01/01/0002', '00:00:00 0000-00-00');
--TEST: pass irregular formats
select datediff(datetime'0:0:0.0 0/0/0', timestamp'00:0:00 00/00/0000');
select datediff('1000-01-01', '0:00:0.0 000-0-00');


--TEST: pass zero timestamp value
select datediff('0-0-0', timestamp'0000-00-00 00:00:00');
select datediff(date'12-12-12', timestamp'00/00/0000 00:00:00');
select datediff(datetime'00:00:00 0000-00-00', timestamp'00:0:00 00/00/0000');
select datediff('12:13:14.999 01/01/0002', timestamp'00:00:00 0000-00-00');
--TEST: pass string value
select datediff('0000-00-00 00:00:00', datetime'00:00:00 0000-00-00');
select datediff('00/00/0000 00:00:00', '01-01-01');
select datediff('00:00:00 00/00/0000', date'12/12/2011');
select datediff('00:00:00 0000-00-00', timestamp'12/12/2000 12:12:12');
--TEST: pass irregular formats
select datediff(timestamp'0:0:0 000-0-00', date'0000-00-00');
select datediff('00/0/000', '0:0:0 12/0/00');


--TEST: pass zero datediff value
select datediff(date'0000-00-00', timestamp'12/12/2000 12:12:12');
select datediff(date'00/00/0000', '0000-00-00');
--TEST: pass string value
select datediff(datetime'12:13:14.999 01/01/0002', '0000-00-00');
select datediff(date'01-01-01', '00/00/0000');
--TEST: pass irregular formats
select datediff(date'0-0-0', '00:00:00 00/00/0000');
select datediff('12/12/2011', '00/0/000');


set system parameters 'return_null_on_function_errors=no';
commit;
--+ holdcas off;
