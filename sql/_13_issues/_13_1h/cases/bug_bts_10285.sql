--TEST: Result of round(date) function is inconsistent with Oracle when passing 'hh'/'mi' to the second(format) parameter.

--10285:
select round(to_timestamp('2012-02-28 13:58:59', 'yyyy-mm-dd hh24:mi:ss'), 'dd');

select round(to_timestamp('2012-02-28 22:58:59', 'yyyy-mm-dd hh24:mi:ss'), 'hh');
select round(to_timestamp('2012-02-28 23:58:59', 'yyyy-mm-dd hh24:mi:ss'), 'hh');

select round(to_timestamp('2012-02-28 13:11:59', 'yyyy-mm-dd hh24:mi:ss'), 'mi');
select round(to_timestamp('2012-02-28 23:59:35', 'yyyy-mm-dd hh24:mi:ss'), 'mi');

select round(to_datetime('2012-02-28 22:58:59.501', 'yyyy-mm-dd hh24:mi:ss.ff'), 'ss');
select round(to_datetime('2012-02-28 23:59:59.999', 'yyyy-mm-dd hh24:mi:ss.ff'), 'ss');

select round(to_datetime('2012-02-28 23:59:59.999', 'yyyy-mm-dd hh24:mi:ss.ff'), 'ff');


--10291:
select round(to_timestamp('2012-12-26 14:30:11', 'yyyy-mm-dd hh24:mi:ss'), 'day');


