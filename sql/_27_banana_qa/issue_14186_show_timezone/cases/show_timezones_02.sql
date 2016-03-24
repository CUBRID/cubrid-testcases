
set timezone 'Europe/Paris';
show timezones;
set timezone '+05:00'; 
show timezones;
select timestamptz'2012-03-20 10:00:00 AM Europe/Berlin';
show timezones;
select timestampltz'2012-03-20 23:00:00 +06:00';
show timezones;
select timestampltz'2012-03-20 23:00:00 -10:00';
show timezones;
select timestampltz'2012-03-20 23:00:00 +12:00';
show timezones;
show full timezones where region_offset='+09:00' and timezone_region='Asia/Seoul';


show full timezones where lower(dst_abbreviation)='cat';

show full timezones where dst_abbreviation='cat';
--'Egypt' using EET all year
show full timezones where dst_abbreviation='EET' and timezone_region='Egypt';

set timezone 'default';
