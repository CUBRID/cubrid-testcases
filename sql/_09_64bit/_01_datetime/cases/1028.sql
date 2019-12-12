create class test_class (date_col date, time_col time, timestamp_col timestamp, datetime_col datetime, datetime_col1 datetime);

insert into test_class values (DATE '01/01/1971', TIME '09:00:00', TIMESTAMP '01/01/1972 10:30:00', DATETIME '1970-01-01 00:00:00.000', DATETIME '1970-01-01 00:00:00.000');
insert into test_class values (DATE '01/02/2009', TIME '19:10:00', TIMESTAMP '01/11/2009 10:31:00', DATETIME '2008-01-12 08:08:08.999', DATETIME '2008-02-12 08:08:08.999');
insert into test_class values (DATE '01/02/2009', TIME '19:10:00', TIMESTAMP '01/11/2009 10:31:00', DATETIME '2008-03-12 08:08:08.999', DATETIME '2008-01-12 08:08:08.999');

SELECT extract(YEAR from datetime_col) FROM test_class order by 1;
SELECT extract(MONTH from datetime_col) FROM test_class order by 1;
SELECT extract(DAY from datetime_col) FROM test_class order by 1;
SELECT extract(HOUR from datetime_col) FROM test_class order by 1;
SELECT extract(MINUTE from datetime_col) FROM test_class order by 1;
SELECT extract(SECOND from datetime_col) FROM test_class order by 1;
SELECT extract(MILLISECOND from datetime_col) FROM test_class order by 1;
SELECT extract(YEAR from DATETIME '2009-01-12 15:04:02.999') FROM test_class order by 1;
SELECT extract(MONTH from DATETIME '2009-01-12 15:04:02.999') FROM test_class order by 1;
SELECT extract(DAY from DATETIME '2009-01-12 15:04:02.999') FROM test_class order by 1;
SELECT extract(HOUR from DATETIME '2009-01-12 15:04:02.999') FROM test_class order by 1;
SELECT extract(MINUTE from DATETIME '2009-01-12 15:04:02.999') FROM test_class order by 1;
SELECT extract(SECOND from DATETIME '2009-01-12 15:04:02.999') FROM test_class order by 1;
SELECT extract(MILLISECOND from DATETIME '2009-01-12 15:04:02.999') FROM test_class order by 1;

drop class test_class;