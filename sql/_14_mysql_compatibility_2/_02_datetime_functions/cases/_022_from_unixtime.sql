--+ holdcas on;
set system parameters 'return_null_on_function_errors = yes';
select if (year(from_unixtime(733466)) = 1970, 'ok','nok') from db_root;
select if (year(from_unixtime('733466')) = 1970, 'ok','nok') from db_root;
select if (month( from_unixtime(7129139)) = 3, 'ok','nok') from db_root;
select if (month(from_unixtime(7129138)) = 3, 'ok','nok') from db_root;
select if (month(from_unixtime(7129138.1)) = 3, 'ok','nok') from db_root;
select if (month(from_unixtime(7129138.6)) = 3, 'ok','nok') from db_root;

create table from_unixtime_tests as select from_unixtime('77777') as col;

SELECT * FROM db_attribute where class_name='from_unixtime_tests';

select if(col=NULL,'nok','ok') from from_unixtime_tests;

drop table from_unixtime_tests;

create view from_unixtime_view(v) as select from_unixtime('777777777') from db_root;

select if (year(v) = 1994, 'ok', 'nok') from from_unixtime_view;

drop from_unixtime_view;

$varchar, $1900.21
select if (from_unixtime(?) = from_unixtime('1900.21'), 'ok', 'nok') as rez from db_root;

$int, $2540
select if (from_unixtime(?) = from_unixtime(2540), 'ok', 'nok') as rez from db_root;

$float, $2540.23
select if (from_unixtime(?) = from_unixtime(2540.23f), 'ok', 'nok') as rez from db_root;

$double, $3540.23
select if (from_unixtime(?) = from_unixtime(354023e-2), 'ok', 'nok') as rez from db_root;

$numeric, $2540.74
select if (from_unixtime(?) = from_unixtime(2540.74), 'ok', 'nok') as rez from db_root;

$datetime, $01/02/1985 12:13:15
select if (from_unixtime(?) = from_unixtime(date'01/02/1985 12:13:15'), 'ok', 'nok') as rez from db_root;

$datetime, $01/02/1985 12:13:15
select 1 as rez from db_root where from_unixtime(?) = 1;

select if (abs(from_unixtime(unix_timestamp())- current_timestamp)<=1, 'ok', 'nok');
select if (datetime('1970-01-01 00:00:00') + (24*3600-unix_timestamp('1970-01-02')) = from_unixtime(0), 'ok', 'nok');
select if (from_unixtime(unix_timestamp('2000-01-03 09:00:00')) - from_unixtime(unix_timestamp('2000-01-01 07:00:00')) = 2*24*3600 + 2*3600, 'ok', 'nok'); 
select if (from_unixtime(unix_timestamp('2000-01-02 03:04:05'), '%Y-%m-%d %h:%i:%s') = '2000-01-02 03:04:05', 'ok', 'nok');

-- check if ER_DATE_CONVERSION is occured.
select from_unixtime(-1);

-- select from_unixtime(1000000000);

select if (from_unixtime(733466, '%Y') = 1970, 'ok', 'nok') from db_root;
select if (from_unixtime('733466', '%Y') = 1970, 'ok','nok') from db_root;
select if (from_unixtime(7129139, '%m') = 3, 'ok','nok') from db_root;
select if (from_unixtime(7129138, '%m') = 3, 'ok','nok') from db_root;
select if (from_unixtime(7129138.1, '%m') = 3, 'ok','nok') from db_root;
select if (from_unixtime(7129138.6, '%m') = 3, 'ok','nok') from db_root;

create table from_unixtime_tests as select from_unixtime('1234567890','%M %Y %W') as col;

SELECT * FROM db_attribute where class_name='from_unixtime_tests';

select if (from_unixtime('1234567890','%M %Y %W') = col, 'ok', 'nok') from from_unixtime_tests;

drop table from_unixtime_tests;

create view from_unixtime_view(v) as select from_unixtime('1234567890','%M %Y %W') from db_root;

select if (from_unixtime('1234567890','%M %Y %W') = v, 'ok', 'nok') from from_unixtime_view;

drop from_unixtime_view;

$varchar, $1234567890, $varchar, $%D %y %a %d %m %b %j
select if (from_unixtime(?,?) = from_unixtime('1234567890', '%D %y %a %d %m %b %j'), 'ok', 'nok') from db_root;

$varchar, $1234567890, $nchar, $%D %y %a %d %m %b %j
select if (from_unixtime(?,?) = from_unixtime('1234567890',N'%D %y %a %d %m %b %j'), 'ok', 'nok') from db_root;

$int, $1234567890, $varchar, $%D %y %a %d %m %b %j
select if (from_unixtime(?,?) = from_unixtime(1234567890, '%D %y %a %d %m %b %j'), 'ok', 'nok') from db_root;

$int, $1234567890, $nchar, $%D %y %a %d %m %b %j
select if (from_unixtime(?,?) = from_unixtime(1234567890, N'%D %y %a %d %m %b %j'), 'ok', 'nok') from db_root;


-- check if ER_DATE_CONVERSION is occured.
select from_unixtime(-1,'%D %y %a %d %m %b %j');

set system parameters 'return_null_on_function_errors = no';

select if (year(from_unixtime(733466)) = 1970, 'ok','nok') from db_root;
select if (year(from_unixtime('733466')) = 1970, 'ok','nok') from db_root;
select if (month( from_unixtime(7129139)) = 3, 'ok','nok') from db_root;
select if (month(from_unixtime(7129138)) = 3, 'ok','nok') from db_root;
select if (month(from_unixtime(7129138.1)) = 3, 'ok','nok') from db_root;
select if (month(from_unixtime(7129138.6)) = 3, 'ok','nok') from db_root;

create table from_unixtime_tests as select from_unixtime('77777') as col;

SELECT * FROM db_attribute where class_name='from_unixtime_tests';

select if(col=NULL,'nok','ok') from from_unixtime_tests;

drop table from_unixtime_tests;

create view from_unixtime_view(v) as select from_unixtime('777777777') from db_root;

select if (year(v) = 1994, 'ok', 'nok') from from_unixtime_view;

drop from_unixtime_view;

$varchar, $1900.21
select if (from_unixtime(?) = from_unixtime('1900.21'), 'ok', 'nok') as rez from db_root;

$int, $2540
select if (from_unixtime(?) = from_unixtime(2540), 'ok', 'nok') as rez from db_root;

$float, $2540.23
select if (from_unixtime(?) = from_unixtime(2540.23f), 'ok', 'nok') as rez from db_root;

$double, $3540.23
select if (from_unixtime(?) = from_unixtime(354023e-2), 'ok', 'nok') as rez from db_root;

$numeric, $2540.74
select if (from_unixtime(?) = from_unixtime(2540.74), 'ok', 'nok') as rez from db_root;

$datetime, $01/02/1985 12:13:15
select if (from_unixtime(?) = from_unixtime(date'01/02/1985 12:13:15'), 'ok', 'nok') as rez from db_root;

$datetime, $01/02/1985 12:13:15
select 1 as rez from db_root where from_unixtime(?) = 1;

select if (abs(from_unixtime(unix_timestamp()) -current_timestamp)<=1, 'ok', 'nok');
select if (datetime('1970-01-01 00:00:00') + (24*3600-unix_timestamp('1970-01-02')) = from_unixtime(0), 'ok', 'nok');
select if (from_unixtime(unix_timestamp('2000-01-03 09:00:00')) - from_unixtime(unix_timestamp('2000-01-01 07:00:00')) = 2*24*3600 + 2*3600, 'ok', 'nok'); 
select if (from_unixtime(unix_timestamp('2000-01-02 03:04:05'), '%Y-%m-%d %h:%i:%s') = '2000-01-02 03:04:05', 'ok', 'nok');

-- check if ER_DATE_CONVERSION is occured.
select from_unixtime(-1);

select from_unixtime(1000000000);

select if (from_unixtime(733466, '%Y') = 1970, 'ok', 'nok') from db_root;
select if (from_unixtime('733466', '%Y') = 1970, 'ok','nok') from db_root;
select if (from_unixtime(7129139, '%m') = 3, 'ok','nok') from db_root;
select if (from_unixtime(7129138, '%m') = 3, 'ok','nok') from db_root;
select if (from_unixtime(7129138.1, '%m') = 3, 'ok','nok') from db_root;
select if (from_unixtime(7129138.6, '%m') = 3, 'ok','nok') from db_root;

create table from_unixtime_tests as select from_unixtime('1234567890','%M %Y %W') as col;

SELECT * FROM db_attribute where class_name='from_unixtime_tests';

select if (from_unixtime('1234567890','%M %Y %W') = col, 'ok', 'nok') from from_unixtime_tests;

drop table from_unixtime_tests;

create view from_unixtime_view(v) as select from_unixtime('1234567890','%M %Y %W') from db_root;

select if (from_unixtime('1234567890','%M %Y %W') = v, 'ok', 'nok') from from_unixtime_view;

drop from_unixtime_view;

$varchar, $1234567890, $varchar, $%D %y %a %d %m %b %j
select if (from_unixtime(?,?) = from_unixtime('1234567890', '%D %y %a %d %m %b %j'), 'ok', 'nok') from db_root;

$varchar, $1234567890, $nchar, $%D %y %a %d %m %b %j
select if (from_unixtime(?,?) = from_unixtime('1234567890',N'%D %y %a %d %m %b %j'), 'ok', 'nok') from db_root;

$int, $1234567890, $varchar, $%D %y %a %d %m %b %j
select if (from_unixtime(?,?) = from_unixtime(1234567890, '%D %y %a %d %m %b %j'), 'ok', 'nok') from db_root;

$int, $1234567890, $nchar, $%D %y %a %d %m %b %j
select if (from_unixtime(?,?) = from_unixtime(1234567890, N'%D %y %a %d %m %b %j'), 'ok', 'nok') from db_root;


-- check if ER_DATE_CONVERSION is occured.
select from_unixtime(-1,'%D %y %a %d %m %b %j');
commit;
--+ holdcas off;
