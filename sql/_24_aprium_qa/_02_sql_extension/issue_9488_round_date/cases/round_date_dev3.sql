--test round function for datetime
--normal
select round(to_datetime('11:59:59.499 pm 2012-02-28'), 'yy') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-02-28'), 'mm') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-02-28'), 'dd') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-02-28'), 'hh') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-02-28'), 'mi') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-02-28'), 'ss') from db_root;

--using host variable
prepare s from 'select round(to_date(?), ?) from db_root';
--round with year
execute s using '2012-07-01', 'yy';
execute s using '2012-06-30', 'yy';
execute s using '2012-01-01', 'yyyy';
execute s using '2012-12-31', 'yyyy';

--round with month
prepare s from 'select round(?, ''mm'')';

execute s using timestamp'11:59:59 pm 2012-02-15';
execute s using timestamp'11:59:59 pm 2012-02-16';
execute s using timestamp'11:59:59 pm 2012-12-15';
execute s using timestamp'11:59:59 pm 2012-12-16';

--round with day
prepare s from 'select round(to_datetime(?), ''dd'') from db_root order by 1';

execute s using '11:59:59.499 am 2012-02-28';
execute s using '11:59:59.499 am 2012-02-29';
execute s using '11:59:59.500 am 2011-02-28';
execute s using '11:59:59.500 am 2012-12-31';

execute s using '11:59:59.499 pm 2012-02-28';
execute s using '11:59:59.499 pm 2012-02-29';
execute s using '11:59:59.500 pm 2011-02-28';
execute s using '11:59:59.500 pm 2012-12-31';

--round with hour, minute, second
prepare s from 'select round(to_datetime(?), ?)';

execute s using '01:29:59.499 am 2012-02-28', 'h';
execute s using '11:59:59.499 am 2012-02-29', 'h';
execute s using '11:59:59.500 pm 2011-02-28', 'hh';
execute s using '11:59:59.500 pm 2012-12-31', 'hh';

execute s using '01:59:29.499 am 2012-02-28', 'mi';
execute s using '01:59:30.499 am 2012-02-29', 'mi';
execute s using '11:59:29.499 pm 2011-02-28', 'ss';
execute s using '11:59:30.499 pm 2012-12-31', 'ss';

--for leap year
execute s using '11:59:59.500 pm 2012-02-28', 'yy';
execute s using '11:59:59.500 pm 2012-02-28', 'mm';
execute s using '11:59:59.500 pm 2012-02-28', 'dd';
execute s using '11:59:59.500 pm 2012-02-28', 'hh';
execute s using '11:59:59.500 pm 2012-02-28', 'mi';
execute s using '11:59:59.500 pm 2012-02-28', 'ss';

--for non leap year
execute s using '11:59:59.500 pm 2011-02-28', 'yy';
execute s using '11:59:59.500 pm 2011-02-28', 'mm';
execute s using '11:59:59.500 pm 2011-02-28', 'dd';
execute s using '11:59:59.500 pm 2011-02-28', 'hh';
execute s using '11:59:59.500 pm 2011-02-28', 'mi';
execute s using '11:59:59.500 pm 2011-02-28', 'ss';

--for round up year:
execute s using '11:59:59.500 am 2011-12-31', 'yy';
execute s using '11:59:59.500 am 2011-12-31', 'mm';
execute s using '11:59:59.500 pm 2011-12-31', 'dd';
execute s using '11:59:59.500 pm 2011-12-31', 'hh';
execute s using '11:59:59.500 pm 2011-12-31', 'mi';
execute s using '11:59:59.500 pm 2011-12-31', 'ss';

--for quater:
prepare s from 'select round(to_datetime(?), ''q'')';

execute s using '11:59:59.499 pm 2012-02-15';
execute s using '11:59:59.499 pm 2012-02-16';

execute s using '11:59:59.499 pm 2012-05-15';
execute s using '11:59:59.499 pm 2012-05-16';

execute s using '11:59:59.499 pm 2012-08-15';
execute s using '11:59:59.499 pm 2012-08-16';

execute s using '11:59:59.499 pm 2012-11-15';
execute s using '11:59:59.499 pm 2012-11-16';

--for day:
prepare s from 'select round(to_datetime(?), ''day'')';

execute s using '11:59:59.499 pm 2012-12-26';
execute s using '11:59:59.499 pm 2012-12-27';
execute s using '11:59:59.499 pm 2012-12-28';
execute s using '11:59:59.499 pm 2012-12-29';
execute s using '11:59:59.499 pm 2012-12-30';
execute s using '11:59:59.499 pm 2012-12-31';
execute s using '11:59:59.499 pm 2013-01-01';
execute s using '11:59:59.499 pm 2013-01-02';
execute s using '11:59:59.499 pm 2013-01-03';
execute s using '11:59:59.499 pm 2013-01-04';
execute s using '11:59:59.499 pm 2013-01-05';

--boundary check
select round(to_datetime('11:59:59.999 pm 9999-12-31'), 'yy');
select round(to_date('9999-12-31'), 'q');
select round(to_date('9999-12-31'), 'day');
select round(to_date('0001-01-01'), 'day');

--negative
select round(to_datetime('11:59:59.499 pm 2013-01-05'), 'test');
select round(to_datetime('11:59:59.499 pm 2013-01-05'), 3);
select round(123.456 , 'yy');
select round('2012', 'yyyy');
select round(date'0000-00-00', 'q');

--import
--basic test
select round(to_date('2012-10-26'), 'yyyy');
select round(to_date('2012-10-26'), 'yy');
select round(to_date('2012-10-26'), 'mon');
select round(to_date('2012-10-26'), 'mm');
select round(to_date('2012-10-26'), 'dd');
select round(to_date('2012-10-26'), 'hh');
select round(to_date('2012-10-26'), 'mi');
select round(to_date('2012-10-26'), 'ss');
select round(to_date('2012-10-26'), 'ff');
select round(to_date('2012-10-26'), 'day');
select round(to_date('2012-10-26'), 'dy');
select round(to_date('2012-10-26'), 'q');

select round(to_date('2012-10-26'), cast('yyyy' as varchar(10)));
select round(to_date('2012-10-26'), cast('yy' as varchar(10)));
select round(to_date('2012-10-26'), cast('mon' as varchar(10)));
select round(to_date('2012-10-26'), cast('mm' as varchar(10)));
select round(to_date('2012-10-26'), cast('dd' as varchar(10)));
select round(to_date('2012-10-26'), cast('hh' as varchar(10)));
select round(to_date('2012-10-26'), cast('mi' as varchar(10)));
select round(to_date('2012-10-26'), cast('ss' as varchar(10)));
select round(to_date('2012-10-26'), cast('ff' as varchar(10)));
select round(to_date('2012-10-26'), cast('day' as varchar(10)));
select round(to_date('2012-10-26'), cast('dy' as varchar(10)));
select round(to_date('2012-10-26'), cast('q' as varchar(10)));

select round(to_date('2012-10-26'), N'yyyy');
select round(to_date('2012-10-26'), N'yy');
select round(to_date('2012-10-26'), N'mon');
select round(to_date('2012-10-26'), N'mm');
select round(to_date('2012-10-26'), N'dd');
select round(to_date('2012-10-26'), N'hh');
select round(to_date('2012-10-26'), N'mi');
select round(to_date('2012-10-26'), N'ss');
select round(to_date('2012-10-26'), N'ff');
select round(to_date('2012-10-26'), N'day');
select round(to_date('2012-10-26'), N'dy');
select round(to_date('2012-10-26'), N'q');

select round(to_date('2012-10-26'), cast(N'yyyy' as nchar varying(10)));
select round(to_date('2012-10-26'), cast(N'yy' as nchar varying(10)));
select round(to_date('2012-10-26'), cast(N'mon' as nchar varying(10)));
select round(to_date('2012-10-26'), cast(N'mm' as nchar varying(10)));
select round(to_date('2012-10-26'), cast(N'dd' as nchar varying(10)));
select round(to_date('2012-10-26'), cast(N'hh' as nchar varying(10)));
select round(to_date('2012-10-26'), cast(N'mi' as nchar varying(10)));
select round(to_date('2012-10-26'), cast(N'ss' as nchar varying(10)));
select round(to_date('2012-10-26'), cast(N'ff' as nchar varying(10)));
select round(to_date('2012-10-26'), cast(N'day' as nchar varying(10)));
select round(to_date('2012-10-26'), cast(N'dy' as nchar varying(10)));
select round(to_date('2012-10-26'), cast(N'q' as nchar varying(10)));

select round(datetime'2012-10-21 1:2:3', 'yyyy');
select round(datetime'2012-10-22 4:5:6', 'yy');
select round(datetime'2012-10-23 7:8:9', 'mon');
select round(datetime'2012-10-24 10:11:12', 'mm');
select round(datetime'2012-10-25 13:14:15', 'dd');
--NOK
select round(datetime'2012-10-26 16:17:18', 'hh');
--NOK
select round(datetime'2012-10-27 19:20:21', 'mi');
--NOK
select round(datetime'2012-10-28 22:23:24', 'ss');
select round(datetime'2012-10-29 1:2:3', 'ff');
select round(datetime'2012-10-30 4:5:6', 'day');
select round(datetime'2012-10-31 7:8:9', 'dy');
select round(datetime'2012-11-1 10:11:12', 'q');

select round(datetime'2012-10-26', cast('yyyy' as varchar(10)));
select round(datetime'2012-10-26', cast('yy' as varchar(10)));
select round(datetime'2012-10-26', cast('mon' as varchar(10)));
select round(datetime'2012-10-26', cast('mm' as varchar(10)));
select round(datetime'2012-10-26', cast('dd' as varchar(10)));
select round(datetime'2012-10-26', cast('hh' as varchar(10)));
select round(datetime'2012-10-26', cast('mi' as varchar(10)));
select round(datetime'2012-10-26', cast('ss' as varchar(10)));
select round(datetime'2012-10-26', cast('ff' as varchar(10)));
select round(datetime'2012-10-26', cast('day' as varchar(10)));
select round(datetime'2012-10-26', cast('dy' as varchar(10)));
select round(datetime'2012-10-26', cast('q' as varchar(10)));

select round(datetime'2012-10-26', N'yyyy');
select round(datetime'2012-10-26', N'yy');
select round(datetime'2012-10-26', N'mon');
select round(datetime'2012-10-26', N'mm');
select round(datetime'2012-10-26', N'dd');
select round(datetime'2012-10-26', N'hh');
select round(datetime'2012-10-26', N'mi');
select round(datetime'2012-10-26', N'ss');
select round(datetime'2012-10-26', N'ff');
select round(datetime'2012-10-26', N'day');
select round(datetime'2012-10-26', N'dy');
select round(datetime'2012-10-26', N'q');

select round(datetime'2012-10-26', cast(N'yyyy' as nchar varying(10)));
select round(datetime'2012-10-26', cast(N'yy' as nchar varying(10)));
select round(datetime'2012-10-26', cast(N'mon' as nchar varying(10)));
select round(datetime'2012-10-26', cast(N'mm' as nchar varying(10)));
select round(datetime'2012-10-26', cast(N'dd' as nchar varying(10)));
select round(datetime'2012-10-26', cast(N'hh' as nchar varying(10)));
select round(datetime'2012-10-26', cast(N'mi' as nchar varying(10)));
select round(datetime'2012-10-26', cast(N'ss' as nchar varying(10)));
select round(datetime'2012-10-26', cast(N'ff' as nchar varying(10)));
select round(datetime'2012-10-26', cast(N'day' as nchar varying(10)));
select round(datetime'2012-10-26', cast(N'dy' as nchar varying(10)));
select round(datetime'2012-10-26', cast(N'q' as nchar varying(10)));

select round(timestamp'2012-10-21 1:2:3', 'yyyy');
select round(timestamp'2012-10-22 4:5:6', 'yy');
select round(timestamp'2012-10-23 7:8:9', 'mon');
select round(timestamp'2012-10-24 10:11:12', 'mm');
select round(timestamp'2012-10-25 13:14:15', 'dd');
--NOK
select round(timestamp'2012-10-26 16:17:18', 'hh');
--NOK
select round(timestamp'2012-10-27 19:20:21', 'mi');
--NOK
select round(timestamp'2012-10-28 22:23:24', 'ss');
select round(timestamp'2012-10-29 1:2:3', 'ff');
select round(timestamp'2012-10-30 4:5:6', 'day');
select round(timestamp'2012-10-31 7:8:9', 'dy');
select round(timestamp'2012-11-1 10:11:12', 'q');

select round(timestamp'2012-10-26', cast('yyyy' as varchar(10)));
select round(timestamp'2012-10-26', cast('yy' as varchar(10)));
select round(timestamp'2012-10-26', cast('mon' as varchar(10)));
select round(timestamp'2012-10-26', cast('mm' as varchar(10)));
select round(timestamp'2012-10-26', cast('dd' as varchar(10)));
select round(timestamp'2012-10-26', cast('hh' as varchar(10)));
select round(timestamp'2012-10-26', cast('mi' as varchar(10)));
select round(timestamp'2012-10-26', cast('ss' as varchar(10)));
select round(timestamp'2012-10-26', cast('ff' as varchar(10)));
select round(timestamp'2012-10-26', cast('day' as varchar(10)));
select round(timestamp'2012-10-26', cast('dy' as varchar(10)));
select round(timestamp'2012-10-26', cast('q' as varchar(10)));

select round(timestamp'2012-10-26', N'yyyy');
select round(timestamp'2012-10-26', N'yy');
select round(timestamp'2012-10-26', N'mon');
select round(timestamp'2012-10-26', N'mm');
select round(timestamp'2012-10-26', N'dd');
select round(timestamp'2012-10-26', N'hh');
select round(timestamp'2012-10-26', N'mi');
select round(timestamp'2012-10-26', N'ss');
select round(timestamp'2012-10-26', N'ff');
select round(timestamp'2012-10-26', N'day');
select round(timestamp'2012-10-26', N'dy');
select round(timestamp'2012-10-26', N'q');

select round(timestamp'2012-10-26', cast(N'yyyy' as nchar varying(10)));
select round(timestamp'2012-10-26', cast(N'yy' as nchar varying(10)));
select round(timestamp'2012-10-26', cast(N'mon' as nchar varying(10)));
select round(timestamp'2012-10-26', cast(N'mm' as nchar varying(10)));
select round(timestamp'2012-10-26', cast(N'dd' as nchar varying(10)));
select round(timestamp'2012-10-26', cast(N'hh' as nchar varying(10)));
select round(timestamp'2012-10-26', cast(N'mi' as nchar varying(10)));
select round(timestamp'2012-10-26', cast(N'ss' as nchar varying(10)));
select round(timestamp'2012-10-26', cast(N'ff' as nchar varying(10)));
select round(timestamp'2012-10-26', cast(N'day' as nchar varying(10)));
select round(timestamp'2012-10-26', cast(N'dy' as nchar varying(10)));
select round(timestamp'2012-10-26', cast(N'q' as nchar varying(10)));

prepare s from 'select round(?, ''yyyy'')';
execute s using date'2012-12-23';
execute s using datetime'2012-12-23 12:23:45';
execute s using timestamp'2012-12-23 12:23:45';

prepare s from 'select round(date''2012-12-23'', ?)';
execute s using 'yyyy';
execute s using 'yy';
execute s using 'mon';
execute s using 'mm';
execute s using 'dd';
execute s using 'hh';
execute s using 'mi';
execute s using 'ss';
execute s using 'ff';
execute s using 'day';
execute s using 'dy';
execute s using 'q';

execute s using N'yyyy';
execute s using N'yy';
execute s using N'mon';
execute s using N'mm';
execute s using N'dd';
execute s using N'hh';
execute s using N'mi';
execute s using N'ss';
execute s using N'ff';
execute s using N'day';
execute s using N'dy';
execute s using N'q';

prepare s from 'select round(datetime''2012-12-23 23:59:59'', ?)';
execute s using 'yyyy';
execute s using 'yy';
execute s using 'mon';
execute s using 'mm';
execute s using 'dd';
execute s using 'hh';
execute s using 'mi';
--NOK
execute s using 'ss';
--NOK
execute s using 'ff';
execute s using 'day';
execute s using 'dy';
execute s using 'q';

execute s using N'yyyy';
execute s using N'yy';
execute s using N'mon';
execute s using N'mm';
execute s using N'dd';
execute s using N'hh';
execute s using N'mi';
--NOK
execute s using N'ss';
--NOK
execute s using N'ff';
execute s using N'day';
execute s using N'dy';
execute s using N'q';

prepare s from 'select round(timestamp''2012-12-23 23:59:59'', ?)';
execute s using 'yyyy';
execute s using 'yy';
execute s using 'mon';
execute s using 'mm';
execute s using 'dd';
execute s using 'hh';
execute s using 'mi';
--NOK
execute s using 'ss';
--NOK
execute s using 'ff';
execute s using 'day';
execute s using 'dy';
execute s using 'q';

execute s using N'yyyy';
execute s using N'yy';
execute s using N'mon';
execute s using N'mm';
execute s using N'dd';
execute s using N'hh';
execute s using N'mi';
--NOK
execute s using N'ss';
--NOK
execute s using N'ff';
execute s using N'day';
execute s using N'dy';
execute s using N'q';

--negative
select round('2010-1-2', 'a');
select round('2010-1-2', 3);
select round(1234, 'yyyy');
select round(timestamp'2012-10-26', cast(N'yyyy' as nchar varying(3)));

--auto cast to date or double:
--1 argument:
prepare s from 'select round(?)';
execute s using datetime'11:59:59.500 am 2012-12-21';
execute s using datetime'11:59:59.500 pm 2012-12-21';
execute s using date'2012-12-21';
execute s using '1.2345';

--2 arguments:
prepare s from 'select round(to_datetime(?))';
execute s using '11:59:59.500 am 2012-12-21';
execute s using '11:59:59.500 pm 2012-12-21';
--negative
execute s using '1.2345';
execute s using '1.2345';
select round(123, 'default');
select round(to_date('11:59:59.500 am 2012-12-21'), 'default');
