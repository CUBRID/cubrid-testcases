
set timezone '+9:00';

autocommit off;
set system parameters 'return_null_on_function_errors = no';

drop table if exists timediff_test;
CREATE table timediff_test(
date_col DATE,
time_col time,
timestamp_col timestampltz,
datetime_col datetimeltz,
char_col char(255),
varchar_col varchar(255),
nchar_col nchar(255),
varnchar_col nchar varying(255)

);
insert into timediff_test values( date'2010-01-01', time'12:34:56', timestampltz'2010-01-01 01:23:45 am', datetimeltz'2010-01-01 12:34:56.123 am', '2010-02-02', '2010-02-02 12:00:00 am' ,N'14:00:34 am', N'2010-03-03 09:06:03.456 am');

select timediff (date_col, date_col) from timediff_test;

select timediff (date_col, time_col) from timediff_test;

select timediff (date_col, timestamp_col) from timediff_test;

select timediff (date_col, datetime_col) from timediff_test;


select timediff (time_col , time_col) from timediff_test;

select timediff (time_col , date_col) from timediff_test;

select timediff (time_col , timestamp_col) from timediff_test;

select timediff (time_col , datetime_col) from timediff_test;


select timediff (timestamp_col , time_col) from timediff_test;

select timediff (timestamp_col , date_col) from timediff_test;

select timediff (timestamp_col , timestamp_col) from timediff_test;

select timediff (timestamp_col , datetime_col) from timediff_test;


select timediff (datetime_col , time_col) from timediff_test;

select timediff (datetime_col , date_col) from timediff_test;

select timediff (datetime_col , timestamp_col) from timediff_test;

select timediff (datetime_col , datetime_col) from timediff_test;

select timediff (date_col, varchar_col) from timediff_test;

select timediff (date_col, varnchar_col) from timediff_test;

select timediff (date_col, char_col) from timediff_test;

select timediff (date_col, nchar_col) form timediff_test;


select timediff (timestamp_col, varchar_col) from timediff_test;

select timediff (timestamp_col, varnchar_col) from timediff_test;

select timediff (timestamp_col, char_col) from timediff_test;

select timediff (timestamp_col, nchar_col) from timediff_test;


select timediff (datetime_col, varchar_col) from timediff_test;

select timediff (datetime_col, varnchar_col) from timediff_test;

select timediff (datetime_col,char_col) from timediff_test;

select timediff (datetime_col,nchar_col) from timediff_test;


select timediff (varnchar_col, varchar_col) from timediff_test;

select timediff (varnchar_col,char_col) from timediff_test;

select timediff (varnchar_col,nchar_col) from timediff_test;

select timediff (varnchar_col, varnchar_col) from timediff_test;


select timediff (varchar_col, varchar_col) from timediff_test;

select timediff (varchar_col,char_col) from timediff_test;

select timediff (varchar_col,nchar_col) from timediff_test;

select timediff (varchar_col, varnchar_col) from timediff_test;


select timediff (nchar_col, varchar_col) from timediff_test;

select timediff (nchar_col,char_col) from timediff_test;

select timediff (nchar_col,nchar_col) from timediff_test;

select timediff (nchar_col, varnchar_col) from timediff_test;


select timediff (char_col, varchar_col) from timediff_test;

select timediff (char_col,char_col) from timediff_test;

select timediff (char_col,nchar_col) from timediff_test;

select timediff (char_col, varnchar_col) from timediff_test;

select timediff (date'2010-01-02', date'2010-01-01');

select timediff (date'2010-01-01', date'2010-01-01');

select timediff (date'2010-01-01', date'2010-01-02');

select timediff (date'2010-01-01', timestampltz'1990-01-01 03:04:05');

select timediff (datetimeltz'2010-01-01 12:34:56.123', datetimeltz'2010-01-01 09:08:07');

select timediff (datetimeltz'2010-01-01 09:08:07', datetimeltz'2010-01-01 12:34:56.123');

select timediff (datetimeltz'2010-01-01 09:08:07', timestampltz'2010-01-02 08:07:06');

select timediff (datetimeltz'2010-01-01 09:08:07', date'2010-01-01');

select timediff (time'17:18:19',time'12:05:52');

select timediff ('17:18:19',time'12:05:52');

select timediff (time'12:05:52',time'17:18:19');

select timediff (time'12:00:00', date'2010-01-01');

select timediff (time'12:00:00', datetimeltz'2010-01-01 12:00:00');

select timediff (time'12:00:00', timestampltz'2010-01-01 12:00:00');

select timediff ('17:18:19', '12:05:52');

select timediff ('12:05:52', '17:18:19');

select timediff ('2010-01-01 06:53:45', '2010-01-01 03:04:05');

select timediff (N'17:18:19', N'12:05:52');

select timediff (N'17:18:19', '12:05:52');

$varchar, $17:18:19, $varchar, $12:05:52

select timediff(?,?);

$varchar, $17:18:19

select timediff(?,time'12:05:52');

$varchar, $17:18:19, $varchar, $2010-01-01

select timediff(?,?);

$timeltz, $12:00:00, $timeltz, $11:00:00

select timediff(?,?);


drop table timediff_test;


set system parameters 'return_null_on_function_errors = yes';

CREATE table timediff_test(
date_col DATE,
time_col time,
timestamp_col timestampltz,
datetime_col datetimeltz,
char_col char(255),
varchar_col varchar(255),
nchar_col nchar(255),
varnchar_col nchar varying(255)

);
insert into timediff_test values( date'2010-01-01', time'12:34:56', timestampltz'2010-01-01 01:23:45 am', datetimeltz'2010-01-01 12:34:56.123 am', '2010-02-02', '2010-02-02 12:00:00 am' ,N'14:00:34', N'2010-03-03 09:06:03.456 am');

select timediff (date_col, date_col) from timediff_test;

select timediff (date_col, time_col) from timediff_test;

select timediff (date_col, timestamp_col) from timediff_test;

select timediff (date_col, datetime_col) from timediff_test;


select timediff (time_col , time_col) from timediff_test;

select timediff (time_col , date_col) from timediff_test;

select timediff (time_col , timestamp_col) from timediff_test;

select timediff (time_col , datetime_col) from timediff_test;


select timediff (timestamp_col , time_col) from timediff_test;

select timediff (timestamp_col , date_col) from timediff_test;

select timediff (timestamp_col , timestamp_col) from timediff_test;

select timediff (timestamp_col , datetime_col) from timediff_test;


select timediff (datetime_col , time_col) from timediff_test;

select timediff (datetime_col , date_col) from timediff_test;

select timediff (datetime_col , timestamp_col) from timediff_test;

select timediff (datetime_col , datetime_col) from timediff_test;

select timediff (date_col, varchar_col) from timediff_test;

select timediff (date_col, varnchar_col) from timediff_test;

select timediff (date_col, char_col) from timediff_test;

select timediff (date_col, nchar_col) form timediff_test;


select timediff (timestamp_col, varchar_col) from timediff_test;

select timediff (timestamp_col, varnchar_col) from timediff_test;

select timediff (timestamp_col, char_col) from timediff_test;

select timediff (timestamp_col, nchar_col) from timediff_test;


select timediff (datetime_col, varchar_col) from timediff_test;

select timediff (datetime_col, varnchar_col) from timediff_test;

select timediff (datetime_col,char_col) from timediff_test;

select timediff (datetime_col,nchar_col) from timediff_test;


select timediff (varnchar_col, varchar_col) from timediff_test;

select timediff (varnchar_col,char_col) from timediff_test;

select timediff (varnchar_col,nchar_col) from timediff_test;

select timediff (varnchar_col, varnchar_col) from timediff_test;


select timediff (varchar_col, varchar_col) from timediff_test;

select timediff (varchar_col,char_col) from timediff_test;

select timediff (varchar_col,nchar_col) from timediff_test;

select timediff (varchar_col, varnchar_col) from timediff_test;


select timediff (nchar_col, varchar_col) from timediff_test;

select timediff (nchar_col,char_col) from timediff_test;

select timediff (nchar_col,nchar_col) from timediff_test;

select timediff (nchar_col, varnchar_col) from timediff_test;


select timediff (char_col, varchar_col) from timediff_test;

select timediff (char_col,char_col) from timediff_test;

select timediff (char_col,nchar_col) from timediff_test;

select timediff (char_col, varnchar_col) from timediff_test;

select timediff (date'2010-01-02', date'2010-01-01');

select timediff (date'2010-01-01', date'2010-01-01');

select timediff (date'2010-01-01', date'2010-01-02');

select timediff (date'2010-01-01', timestampltz'1990-01-01 03:04:05');

select timediff (datetimeltz'2010-01-01 12:34:56.123', datetimeltz'2010-01-01 09:08:07');

select timediff (datetimeltz'2010-01-01 09:08:07', datetimeltz'2010-01-01 12:34:56.123');

select timediff (datetimeltz'2010-01-01 09:08:07', timestampltz'2010-01-02 08:07:06');

select timediff (datetimeltz'2010-01-01 09:08:07', date'2010-01-01');

select timediff (time'17:18:19',time'12:05:52');

select timediff ('17:18:19',time'12:05:52');

select timediff (time'12:05:52',time'17:18:19');

select timediff (time'12:00:00', date'2010-01-01');

select timediff (time'12:00:00', datetimeltz'2010-01-01 12:00:00');

select timediff (time'12:00:00', timestampltz'2010-01-01 12:00:00');

select timediff ('17:18:19', '12:05:52');

select timediff ('12:05:52', '17:18:19');

select timediff ('2010-01-01 06:53:45', '2010-01-01 03:04:05');

select timediff (N'17:18:19', N'12:05:52');

select timediff (N'17:18:19', '12:05:52');

$varchar, $17:18:19, $varchar, $12:05:52

select timediff(?,?);

$varchar, $17:18:19

select timediff(?,time'12:05:52');

$varchar, $17:18:19, $varchar, $2010-01-01

select timediff(?,?);

$timeltz, $12:00:00, $timeltz, $11:00:00

select timediff(?,?);


drop table timediff_test;

set system parameters 'return_null_on_function_errors = no';
commit;
autocommit on;

set timezone 'Asia/Seoul';
