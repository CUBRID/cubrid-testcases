--test with host variables, with special values
--+ holdcas on;


prepare st from 'select /*+ recompile */ from_tz(?, ?)';

--test: normal values
set @t=time'12:00:00 AM';
set @dt=datetime'2015-10-10 13:30:59.999';
set @offset='-11:30';
set @tz='Africa/Freetown';

execute st using @t, '+2:45';
execute st using time'12:00:00 AM', '-10:45';
--BUG: CUBRIDSUS-16977, resolved
execute st using time'12:00:00 AM', 'Asia/Baghdad';
execute st using time'12:00:00 AM', @offset;
execute st using time'12:00:00 AM', @tz;

execute st using @dt, '+13:59';
execute st using datetime'2015-10-10 13:30:59.999', '+13:59';
execute st using datetime'2015-10-10 13:30:59.999', 'Antarctica/DumontDUrville';
execute st using datetime'2015-10-10 13:30:59.999', @offset;
execute st using datetime'2015-10-10 13:30:59.999', @tz;


set @tz='Asia/Amman';
--test: [er] non-existent values 
execute st using datetime'1976-05-01 12:20:33 AM', @tz;
execute st using datetime'1988-04-01 00:20:33', @tz;
execute st using datetime'2000-03-30 00:00:00', @tz;
--!!! different result in Oracle and Postgre
execute st using datetime'2005-04-01 00:00:00', @tz;

--test: ambiguous values
prepare st from 'select if(from_tz(?, ?)=?, ''ok'', ''nok'')';
execute st using datetime'1977-09-30 23:00:00', @tz, timestamptz'1977-09-30 23:00:00 Asia/Amman EEST';
execute st using datetime'1986-10-02 23:30:00', @tz, timestamptz'1986-10-02 23:30:00 Asia/Amman EEST';
execute st using datetime'1994-09-15 23:30:00', @tz, timestamptz'1994-09-15 23:30:00 Asia/Amman EEST';
execute st using datetime'1996-09-20 00:30:00', @tz, timestamptz'1996-09-19 21:30:00 UTC';
execute st using datetime'2025-10-26 00:00:00', @tz, timestamptz'2025-10-26 6:00:00 Asia/Seoul';
execute st using datetime'1930-12-31 23:50:00', @tz, datetimetz'1930-12-31 23:50:00 Asia/Amman LMT';

prepare st from 'select if(from_tz(?, ?)+3600*1000=?, ''ok'', ''nok'')';
execute st using datetime'1977-09-30 23:00:00', @tz, timestamptz'1977-09-30 23:00:00 Asia/Amman EET';
execute st using datetime'1986-10-02 23:30:00', @tz, timestamptz'1986-10-02 23:30:00 Asia/Amman EET';
execute st using datetime'1994-09-15 23:30:00', @tz, timestamptz'1994-09-15 23:30:00 Asia/Amman EET';
execute st using datetime'1996-09-20 00:30:00', @tz, timestamptz'1996-09-19 22:30:00 UTC';
execute st using datetime'2025-10-26 00:00:00', @tz, timestamptz'2025-10-26 7:00:00 Asia/Seoul';

prepare st from 'select if(from_tz(?, ?)+(23*60+44)*1000=?, ''ok'', ''nok'')';
--BUG: CUBRIDSUS-17063, resolved
execute st using datetime'1930-12-31 23:50:00', @tz, datetimetz'1930-12-31 23:50:00 Asia/Amman EET';

deallocate prepare st;


drop variable @t, @dt, @offset, @tz;


set timezone 'Asia/Seoul';








--+ holdcas off;
