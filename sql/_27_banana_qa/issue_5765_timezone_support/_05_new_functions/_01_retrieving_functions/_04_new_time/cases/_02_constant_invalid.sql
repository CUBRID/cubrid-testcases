--test with constant and invalid values


--test: time value
set timezone '-2:00';
select if(new_time(time'12:13:14', sessiontimezone, 'UTC')=time'14:13:14', 'ok', 'nok');
select if(new_time(time'12:13:14', 'GMT', dbtimezone)=time'21:13:14', 'ok', 'nok');

set timezone '+7:00';
select if(new_time(time'01:02:03', sessiontimezone(), 'Asia/Shanghai')=time'2:2:3', 'ok', 'nok');

--test: datetime
set timezone 'Asia/Bahrain'; 
--3:22:20
--'Asia/Seoul' 8:27:52
select if(new_time(datetime'1654-10-31 23:45:56', (select dbtimezone()), '+8:27')=datetime'1654-10-31 23:45:04', 'ok', 'nok');
select if(new_time(datetime'1654-10-31 23:45:56', (select sessiontimezone()), '+3:25:48')=datetimetz'1654-10-31 23:45:36 Asia/Bahrain', 'ok', 'nok');

select if(new_time(datetime'4897-01-01 00:00:00', 'Europe/Luxembourg', 'Australia/Adelaide')=datetimetz'4897-01-01 9:30:00 Asia/Bahrain', 'ok', 'nok');
select if(new_time(datetime'4897-01-01 00:00:00', '-2:55', 'Europe/Stockholm')=datetime'4897-01-01 3:55:00', 'ok', 'nok');

--test: [er] string
set timezone 'America/Argentina/San_Luis';
select new_time('23:59:59', dbtimezone(), 'Atlantic/Stanley');
select new_time('1900-01-01 09:23:33.123', '+00:00', 'Atlantic/Stanley');

--test: [er] timestamp
select new_time(timestamp'2015-03-01 14:11:45', '-10:30', 'Atlantic/Stanley');
select new_time(systimestamp, sessiontimezone, 'Atlantic/Stanley');

--test: [er] with time zone types
select new_time(timestamptz'2000-05-09 3:10:45', 'Africa/Maputo', 'Atlantic/Stanley');
select new_time(timestampltz'2000-05-09 3:10:45', 'Antarctica/Davis', 'Atlantic/Stanley');
select new_time(datetimetz'2000-05-09 3:10:45.789', 'Africa/Maputo', 'Atlantic/Stanley');
select new_time(datetimeltz'2000-05-09 3:10:45.456', 'Antarctica/Davis', 'Atlantic/Stanley');

--test: [er] invalid values
select new_time(datetime'4897-01-01 00:00:00', 'abc', 'Atlantic/Stanley');
select new_time(time'23:34:33', 'Africa/Chongqing', 'Atlantic/Stanley');
select new_time(sysdatetime, '10:23', 'Atlantic/Stanley');
select new_time(sysdatetime, '-60:23', 'Atlantic/Stanley');



set timezone 'Asia/Seoul';
