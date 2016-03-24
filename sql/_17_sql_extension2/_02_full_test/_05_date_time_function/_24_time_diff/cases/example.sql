--+ holdcas on;
select timediff(time '17:18:19', time '12:05:52');
select timediff('17:18:19','12:05:52');
select timediff('2010-01-01 06:53:45', '2010-01-01 03:04:05');

SELECT TIMEDIFF('2000:01:01 00:00:00', '2000:01:01 00:00:00.000001');
SELECT TIMEDIFF('2008-12-31 23:59:59.000001', '2008-12-30 01:01:01.000002');

set system parameters 'return_null_on_function_errors=yes';
select timediff('2010-01-02 06:53:45', '2010-01-01 03:04:05');
select timediff(time'12:00:00', datetime'2010-01-01 03:04:05');

set system parameters 'return_null_on_function_errors=no';
commit;
--+ holdcas off;
