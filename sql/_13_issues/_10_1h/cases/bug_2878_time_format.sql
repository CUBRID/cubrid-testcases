--+ holdcas on;
evaluate '05/26/2010' into :str_date;
evaluate '11:11:11 AM' into :str_time;
evaluate '11:11:11 AM 05/26/2010' into :str_timestamp;
evaluate '11:11:11.123 AM 05/26/2010' into :str_datetime;

evaluate cast('05/26/2010' as date) into :date_date;
evaluate cast('11:11:11 AM' as time) into :time_time;
evaluate cast('11:11:11 AM 05/26/2010' as timestamp) into :timestamp_timestamp;
evaluate cast('11:11:11.123 AM 05/26/2010' as datetime) into :datetime_datetime;

evaluate '11:11:11 AM' into :expected;

-- time_format string
-- 1
prepare s from 'select time_format (?, ?) as case1 into :result';
execute s using :str_date, '%r';
deallocate prepare s;

-- 2
prepare s from 'select time_format (?, ?) as case2 into :result';
execute s using :str_time, '%r';
deallocate prepare s;

select case when :expected = :result then 'YES' else 'NO' end as case2;

-- 3
prepare s from 'select time_format (?, ?) as case3 into :result';
execute s using :str_timestamp, '%r';
deallocate prepare s;

select case when :expected = :result then 'YES' else 'NO' end as case3;

-- 4
prepare s from 'select time_format (?, ?) as case4 into :result';
execute s using :str_datetime, '%r';
deallocate prepare s;

select case when :expected = :result then 'YES' else 'NO' end as case4;

-- time_format date, time, timestamp, datetime
-- 5
prepare s from 'select time_format (?, ?) as case5 into :result';
execute s using :date_date, '%r';
deallocate prepare s;


-- 6
prepare s from 'select time_format (?, ?) as case6 into :result';
execute s using :time_time, '%r';
deallocate prepare s;

select case when :expected = :result then 'YES' else 'NO' end as case6;

-- 7
prepare s from 'select time_format (?, ?) as case7 into :result';
execute s using :timestamp_timestamp, '%r';
deallocate prepare s;

select case when :expected = :result then 'YES' else 'NO' end as case7;

-- 8
prepare s from 'select time_format (?, ?) as case8 into :result';
execute s using :datetime_datetime, '%r';
deallocate prepare s;

select case when :expected = :result then 'YES' else 'NO' end as case8;


--+ holdcas off;
