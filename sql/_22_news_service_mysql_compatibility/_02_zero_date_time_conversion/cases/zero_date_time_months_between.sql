--TEST: pass zero date/time values to months_between function


--TEST: error, pass zero months_betweentime value
select months_between(datetime'0000-00-00 00:00:00', '2011-11-3');
--TEST: pass zero months_betweentime value with cast func
select months_between(cast(datetime'00/00/0000 00:00:00' as date), cast('0000-00-00 00:00:00' as date));
select months_between(cast(datetime'00:00:00 00/00/0000' as date), cast(timestamp'1999-09-09 12:12:12' as date));
select months_between(cast(datetime'00:00:00 0000-00-00' as date), '0000-00-00');
--TEST: pass string value
select months_between(date'0001-01-01', cast('0000-00-00 00:00:00' as date));
select months_between(cast(datetime'00/00/0000 00:00:00' as date), cast('00/00/0000 00:00:00' as date));
select months_between('11/11/1989', cast('00:00:00 00/00/0000' as date));
select months_between(cast('12:13:14.999 01/01/0002' as date), cast('00:00:00 0000-00-00' as date));
--TEST: pass irregular formats
select months_between(cast(datetime'0:0:0.0 0/0/0' as date), cast(timestamp'00:0:00 00/00/0000' as date));
select months_between('1000-01-01', cast('0:00:0.0 000-0-00' as date));


--TEST: error, pass zero timestamp value
select months_between('0-0-0', timestamp'0000-00-00 00:00:00');
--TEST: pass zero timestamp value with cast func
select months_between(date'12-12-12', cast(timestamp'00/00/0000 00:00:00' as date));
select months_between(cast(datetime'00:00:00 0000-00-00' as date), cast(timestamp'00:0:00 00/00/0000' as date));
select months_between(cast('12:13:14.999 01/01/0002' as date), cast(timestamp'00:00:00 0000-00-00' as date));
--TEST: pass string value
select months_between(cast('0000-00-00 00:00:00' as date), cast(datetime'00:00:00 0000-00-00' as date));
select months_between(cast('00/00/0000 00:00:00' as date), cast('01-01-01' as date));
select months_between(cast('00:00:00 00/00/0000' as date), date'12/12/2011');
select months_between(cast('00:00:00 0000-00-00' as date), cast(timestamp'12/12/2000 12:12:12' as date));
--TEST: pass irregular formats
select months_between(cast(timestamp'0:0:0 000-0-00' as date), '0000-00-00');
select months_between('00/0/000', cast('0:0:0 12/0/00' as date));


--TEST: pass zero months_between value
select months_between(date'0000-00-00', cast(timestamp'12/12/2000 12:12:12' as date));
select months_between(date'00/00/0000', '0000-00-00');
--TEST: pass string value
select months_between(cast(datetime'12:13:14.999 01/01/0002' as date), '0000-00-00');
select months_between(date'01-01-01', '00/00/0000');
--TEST: error, pass irregular formats
select months_between(date'0-0-0', '00:00:00 00/00/0000');
select months_between('12/12/2011', '00/0/000');
