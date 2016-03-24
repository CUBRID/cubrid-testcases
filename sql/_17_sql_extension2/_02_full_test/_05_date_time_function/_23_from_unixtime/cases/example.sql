--cases from dev


SELECT FROM_UNIXTIME(1196440219);

SELECT FROM_UNIXTIME(1196440219) + 0;

SELECT FROM_UNIXTIME(1196440219) + 1;

SELECT FROM_UNIXTIME(1196440219) - 1;

--SELECT FROM_UNIXTIME(UNIX_TIMESTAMP(),'%Y %D %M %h:%i:%s %x');


-- test for valid input
select if ( abs(from_unixtime(unix_timestamp()) - current_timestamp)<100, 'ok', 'nok');
--select from_unixtime(0), if (datetime('1970-01-01 00:00:00') + (24*3600-unix_timestamp('1970-01-02')) = from_unixtime(0), 'ok', 'nok');
select from_unixtime(unix_timestamp('2000-01-03 09:00:00')), from_unixtime(unix_timestamp('2000-01-01 07:00:00')), if (from_unixtime(unix_timestamp('2000-01-03 09:00:00')) - from_unixtime(unix_timestamp('2000-01-01 07:00:00')) = 2*24*3600 + 2*3600, 'ok', 'nok'); 
select from_unixtime(unix_timestamp('2000-01-02 03:04:05')), if (from_unixtime(unix_timestamp('2000-01-02 03:04:05'), '%Y-%m-%d %h:%i:%s') = '2000-01-02 03:04:05', 'ok', 'nok');

