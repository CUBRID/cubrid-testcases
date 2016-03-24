--test with constant and invalid values


--test: time value
set timezone 'Europe/Minsk';
select from_tz(time'12:13:14', sessiontimezone);
select from_tz(time'12:13:14', dbtimezone);

set timezone '+7:00';
select from_tz(time'01:02:03', dbtimezone());
select from_tz(time'01:02:03', sessiontimezone());

--test: datetime
set timezone 'Asia/Bahrain';
select from_tz(datetime'1654-10-31 23:45:56', (select dbtimezone()));
select from_tz(datetime'1654-10-31 23:45:56', (select sessiontimezone()));

select from_tz(datetime'4897-01-01 00:00:00', 'Europe/Luxembourg');
select from_tz(datetime'4897-01-01 00:00:00', '-2:55');

--test: [er] string
set timezone 'America/Argentina/San_Luis';
select from_tz('23:59:59', dbtimezone());
select from_tz('1900-01-01 09:23:33.123', '+00:00');

--test: [er] timestamp
select from_tz(timestamp'2015-03-01 14:11:45', '-10:30');
select from_tz(systimestamp, sessiontimezone);

--test: [er] with time zone types
select from_tz(time'1:2:3', '+4:24');
select from_tz(time'14:56:55', '-12:00');
select from_tz(timestamtz'2000-05-09 3:10:45', 'Africa/Maputo');
select from_tz(timestampltz'2000-05-09 3:10:45', 'Antarctica/Davis');
select from_tz(datetimetz'2000-05-09 3:10:45.789', 'Africa/Maputo');
select from_tz(datetimeltz'2000-05-09 3:10:45.456', 'Antarctica/Davis');

--test: [er] invalid values
select from_tz(datetime'4897-01-01 00:00:00', 'abc');
select from_tz(time'23:34:33', 'Africa/Chongqing');
select from_tz(sysdatetime, '10:23');
select from_tz(sysdatetime, '-60:23');



set timezone 'Asia/Seoul';
