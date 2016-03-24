evaluate '05/26/2010' into :str_date;
evaluate '11:11:11 AM' into :str_time;
evaluate '11:11:11 AM 05/26/2010' into :str_timestamp;
evaluate '11:11:11.123 AM 05/26/2010' into :str_datetime;

evaluate cast('05/26/2010' as date) into :date_date;
evaluate cast('11:11:11 AM' as time) into :time_time;
evaluate cast('11:11:11 AM 05/26/2010' as timestamp) into :timestamp_timestamp;
evaluate cast('11:11:11.123 AM 05/26/2010' as datetime) into :datetime_datetime;

-- 1 string_date
prepare s from 'select date(?) as case1 into :result'
execute s using :str_date
deallocate prepare s;

evaluate '05/26/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

-- 2 string_time
prepare s from 'select date(?) as case2 into :result'
execute s using :str_time
deallocate prepare s;

-- 3 string_timestamp
prepare s from 'select date(?) as case3 into :result'
execute s using :str_timestamp
deallocate prepare s;

evaluate '05/26/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case3;

-- 4 string_datetime
prepare s from 'select date(?) as case4 into :result'
execute s using :str_datetime
deallocate prepare s;

evaluate '05/26/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case4;

-- 5 date
prepare s from 'select date(?) as case5 into :result'
execute s using :date_date
deallocate prepare s;

evaluate '05/26/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case5;

-- 6 time
prepare s from 'select date(?) as case6 into :result'
execute s using :time_time
deallocate prepare s;

-- 7 timestamp
prepare s from 'select date(?) as case7 into :result'
execute s using :timestamp_timestamp
deallocate prepare s;

evaluate '05/26/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case7;

-- 8 timestamp
prepare s from 'select date(?) as case8 into :result'
execute s using :datetime_datetime
deallocate prepare s;

evaluate '05/26/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case8;

