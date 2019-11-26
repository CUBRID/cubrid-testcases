--+ holdcas on;
evaluate '05/26/2010' into :str_date;
evaluate '11:11:11 AM' into :str_time;
evaluate '11:11:11 AM 05/26/2010' into :str_timestamp;
evaluate '11:11:11.123 AM 05/26/2010' into :str_datetime;

evaluate cast('05/26/2010' as date) into :date_date;
evaluate cast('11:11:11 AM' as time) into :time_time;
evaluate cast('11:11:11 AM 05/26/2010' as timestamp) into :timestamp_timestamp;
evaluate cast('11:11:11.123 AM 05/26/2010' as datetime) into :datetime_datetime;

-- date_format string
-- 1
prepare s from 'select date_format (?, ?) as case1 into :result'
execute s using :str_date, '%Y-%c-%d'
deallocate prepare s;

evaluate '2010-5-26' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

-- 2
prepare s from 'select date_format (?, ?) as case2 into :result'
execute s using :str_time, '%Y-%c-%d'
deallocate prepare s;

-- 3
prepare s from 'select date_format (?, ?) as case3 into :result'
execute s using :str_timestamp, '%Y-%c-%d'
deallocate prepare s;

evaluate '2010-5-26' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case3;

-- 4
prepare s from 'select date_format (?, ?) as case4 into :result'
execute s using :str_datetime, '%Y-%c-%d'
deallocate prepare s;

evaluate '2010-5-26' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case4;

-- date_format date, time, timestamp, datetime
-- 5
prepare s from 'select date_format (?, ?) as case5 into :result'
execute s using :date_date, '%Y-%c-%d'
deallocate prepare s;

evaluate '2010-5-26' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case5;

-- 6
prepare s from 'select date_format (?, ?) as case6 into :result'
execute s using :time_time, '%Y-%c-%d'
deallocate prepare s;

-- 7
prepare s from 'select date_format (?, ?) as case7 into :result'
execute s using :timestamp_timestamp, '%Y-%c-%d'
deallocate prepare s;

evaluate '2010-5-26' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case7;

-- 8
prepare s from 'select date_format (?, ?) as case8 into :result'
execute s using :datetime_datetime, '%Y-%c-%d'
deallocate prepare s;

evaluate '2010-5-26' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case8;


--+ holdcas off;
