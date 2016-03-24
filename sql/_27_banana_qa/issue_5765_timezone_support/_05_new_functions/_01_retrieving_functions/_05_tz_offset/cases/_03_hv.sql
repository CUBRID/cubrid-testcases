--test with host variables
--+ holdcas on;


prepare st from 'select tz_offset(?)';

execute st using '0:00';
execute st using 'abc';

execute st using '+2:23';
execute st using '-10:34';
execute st using 'Asia/Thimphu';
execute st using 'Africa/Dakar';
execute st using 'Africa/Niamey';
execute st using 'Africa/Maputo';

set @tz1='Antarctica/Casey';
set @tz2='Pacific/Guam';
execute st using @tz1;
execute st using @tz2;

deallocate prepare st;


drop variable @tz1, @tz2;

set timezone 'Asia/Seoul';

--+ holdcas off;
