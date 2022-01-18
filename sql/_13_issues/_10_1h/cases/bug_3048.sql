-- No error
select format(cast(1.1 as integer), 5);
select format(cast(1.1 as short), 5);
select format(cast(1.1 as bigint), 5);
select format(cast(1.1 as float), 5);
select format(cast(1.1 as double), 5);
select format(cast(1.1 as numeric(10,5)), 5);
select format(cast(1.1 as char varying(10)), 5);
select format(cast(1.1 as char(10)), 5);
select format(cast(1.1 as nchar varying(10)), 5);
select format(cast(1.1 as nchar(10)), 5);

-- return NULL
select format(NULL, 1);
select format(NULL, NULL);

-- Error
select format(cast(B'1' as bit(10)), 5);
select format(cast(B'1' as bit varying(10)), 5);
select format(cast('2010-05-01' as date), 5);
select format(cast('00:00:00' as time), 5);
select format(cast('2010-05-01 00:00:00' as datetime), 5);
select format(cast('2010-05-01 00:00:00' as timestamp), 5);

-- Error
select format(123, -1);
select format(123, cast(1.5 as float));
select format(123, cast(1.5 as double));
select format(123, cast(-1.5 as float));
select format(123, cast(-1.5 as double));
select format(123, -2147483648);
select format(123, 2147483648);
select format(123, -9223372036854775808);
select format(123, 9223372036854775807);
select format(123, a);
select format(123, cast('a' as char varying(10)));
select format(123, cast('a' as char(10)));
select format(123, cast('a' as nchar varying(10)));
select format(123, cast('a' as nchar(10)));
select format(123, cast(1.1 as float));
select format(123, cast(1.1 as double));
select format(123, date'2010-05-01');
select format(123, time'00:00:00');
select format(123, datetime'2010-05-01 00:00:00');
select format(123, timestamp'2010-05-01 00:00:00');
select format(123, NULL);

-- Error
select format(123456789012345678901234567890123456789.0, 0);
select format(cast(123456789012345678901234567890123456789.0 as numeric(38,5)), 0);
select format(cast(0.123456789012345678901234567890123456789 as numeric(38,38)), 1);
select format('123456789012345678901234567890123456789.0', 0);
select format('0.123456789012345678901234567890123456789', 0);

select format(-123456789012345678901234567890123456789.0, 0);
select format(cast(-123456789012345678901234567890123456789.0 as numeric(38,5)), 0);
select format(cast(-0.123456789012345678901234567890123456789 as numeric(38,38)), 1);
select format('-123456789012345678901234567890123456789.0', 0);
select format('-0.123456789012345678901234567890123456789', 0);


select format(1.1, 10);
select format(12.1, 10);
select format(123.1, 10);
select format(1234.1, 10);
select format(12345.1, 10);
select format(123456.1, 10);
select format(1234567.1, 10);
select format(12345678.1, 10);
select format(123456789.1, 10);
select format(1234567890.1, 10);

select format(-1.1, 10);
select format(-12.1, 10);
select format(-123.1, 10);
select format(-1234.1, 10);
select format(-12345.1, 10);
select format(-123456.1, 10);
select format(-1234567.1, 10);
select format(-12345678.1, 10);
select format(-123456789.1, 10);
select format(-1234567890.1, 10);

-- return the same value
select format(1.1, 30);
select format(1.1, 2147483647);

select format(-1.1, 30);
select format(-1.1, 2147483647);

-- return the same value
select format(1.123456789012345678901234567890, 40);
select format(1.1234567890123456789012345678901234567, 40);

-- return 123456789012345678901234567890.1235 
select format(123456789012345678901234567890123.12345, 4);
-- return 123456789012345678901234567890.1234
select format(123456789012345678901234567890123.12344, 4);

-- return 0.12345678901234567890123456790
select format(0.12345678901234567890123456789512345678, 29);
-- return 0.12345678901234567890123456789
select format(0.12345678901234567890123456789412345678, 29);

-- return 0.123456789012345678901234567890
select format(0.12345678901234567890123456789052345678, 30);
-- return 0.123456789012345678901234567891
select format(0.12345678901234567890123456789042345678, 30);

-- return -123456789012345678901234567890.1235 
select format(-123456789012345678901234567890123.12345, 4);
-- return -123456789012345678901234567890.1234
select format(-123456789012345678901234567890123.12344, 4);

-- return -0.12345678901234567890123456790
select format(-0.12345678901234567890123456789512345678, 29);
-- return -0.12345678901234567890123456789
select format(-0.12345678901234567890123456789412345678, 29);

-- return -0.123456789012345678901234567890
select format(-0.12345678901234567890123456789052345678, 30);
-- return -0.123456789012345678901234567891
select format(-0.12345678901234567890123456789042345678, 30);

select cast(0.123456789012345678901234567890 as float);

select cast(0.123456789012345678901234567890 as double);

select format(cast(0.123456789012345678901234567890 as float), 30);

select format(cast(0.123456789012345678901234567890 as double), 30); 

select format(cast(0.123456789012345678901234567890 as monetary), 30);
