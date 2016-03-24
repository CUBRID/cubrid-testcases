--test with host variables, with special values
--+ holdcas on;


prepare st from 'select /*+ recompile */ new_time(?, ?, ?)';

--test: normal values
set @t=time'12:00:00 AM';
set @dt=datetime'2015-10-10 13:30:59.999';
set @offset='-11:30';
set @tz='Africa/Freetown';

execute st using @t, '+2:45', @tz;
execute st using time'12:00:00 AM', '-10:45', @offset;
--BUG: CUBRIDSUS-16977, resolved
execute st using time'12:00:00 AM', 'Asia/Baghdad', @offset;
execute st using time'12:00:00 AM', @offset, @tz;
execute st using time'12:00:00 AM', @tz, 'America/Phoenix';

execute st using @dt, '+13:59', @offset;
execute st using datetime'2015-10-10 13:30:59.999', '+13:59', @tz;
execute st using datetime'2015-10-10 13:30:59.999', 'Antarctica/DumontDUrville', @tz;
execute st using datetime'2015-10-10 13:30:59.999', @offset, 'America/Indiana/Vevay';
execute st using datetime'2015-10-10 13:30:59.999', 'Australia/Lord_Howe', @tz;


set @tz='Europe/Bucharest';
--test: [er] non-existent values -> other timezones
execute st using datetime'1936-04-05 12:20:33 AM', @tz, 'America/New_York';
execute st using datetime'1980-04-05 23:20:33', @tz, 'Asia/Seoul';
--BUG: CUBRIDSUS-17064
execute st using datetime'1931-07-24 00:00:00', @tz, '-00:00';


set @tz='Africa/Tunis';
--test: convert to non-existent values
prepare st from 'select if(new_time(?, ?, ?)=?, ''ok'', ''nok'')';
execute st using datetime'1943-03-29 1:00:00', 'GMT', @tz, datetime'1943-03-29 03:00:00';
execute st using datetime'1944-04-03 10:00:00', 'Asia/Seoul', @tz, '1944-04-03 03:00:00';
execute st using datetime'1911-03-10 23:50:00', 'UTC', @tz, datetime'1911-03-10 23:59:21'; 
execute st using datetime'1911-03-10 23:50:39', 'UTC', @tz, datetime'1911-03-11 00:50:39'; 
execute st using datetime'1911-03-11 00:00:00', 'UTC', @tz, datetime'1911-03-11 1:00:00';


set @tz='America/St_Johns';
--test: north -> south
prepare st from 'select if(new_time(?, ?, ?)=?, ''ok'', ''nok'')';
execute st using datetime'1977-09-30 23:00:00', @tz, 'Pacific/Fiji', datetime'1977-10-01 13:30:00';
execute st using datetime'1986-10-02 23:30:00', @tz, 'America/Montevideo', datetime'1986-10-02 11:00:00 PM';
execute st using datetime'1994-09-15 23:30:00', @tz, 'Pacific/Apia', datetime'1994-09-15 03:00:00.00 PM';
execute st using datetime'1996-09-20 00:30:00', @tz, 'America/Santiago', '1996-09-19 11:00:00 PM';

--test: south -> north
set @tz='America/Argentina/San_Luis';
execute st using datetime'1977-09-30 23:00:00', @tz, 'Asia/Beirut', datetime'1977-10-01 04:00:00';
execute st using datetime'1986-10-02 23:30:00', @tz, 'Asia/Karachi', '1986-10-03 07:30:00';
execute st using datetime'1994-09-15 23:30:00', @tz, 'America/Halifax', datetime'1994-09-15 11:30:00 PM';
execute st using datetime'1996-09-20 00:30:00', @tz, 'Europe/Istanbul', datetime'1996-09-20 06:30:00';


deallocate prepare st;


drop variable @t, @dt, @offset, @tz;


set timezone 'Asia/Seoul';








--+ holdcas off;
