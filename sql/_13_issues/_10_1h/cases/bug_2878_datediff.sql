--+ holdcas on;
evaluate '05/26/2010' into :str_date1;
evaluate '05/20/2010' into :str_date2;
evaluate '11:11:11 AM 05/26/2010' into :str_timestamp1;
evaluate '11:11:11 AM 05/20/2010' into :str_timestamp2;
evaluate '11:11:11.123 AM 05/26/2010' into :str_datetime1;
evaluate '11:11:11.123 AM 05/20/2010' into :str_datetime2;

evaluate cast('05/26/2010' as date) into :date_date1;
evaluate cast('05/20/2010' as date) into :date_date2;
evaluate cast('11:11:11 AM 05/26/2010' as timestamp) into :timestamp_timestamp1;
evaluate cast('11:11:11 AM 05/20/2010' as timestamp) into :timestamp_timestamp2;
evaluate cast('11:11:11.123 AM 05/26/2010' as datetime) into :datetime_datetime1;
evaluate cast('11:11:11.123 AM 05/20/2010' as datetime) into :datetime_datetime2;

-- datediff 
-- 1 string_date - string_date
prepare s from 'select datediff (?, ?) as case1 into :result'
execute s using :str_date1, :str_date2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

-- 2 string_date - string_timestamp
prepare s from 'select datediff (?, ?) as case2 into :result'
execute s using :str_date1, :str_timestamp2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case2;

-- 3 string_date - string_datetime
prepare s from 'select datediff (?, ?) as case3 into :result'
execute s using :str_date1, :str_datetime2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case3;

-- 4 string_date - date
prepare s from 'select datediff (?, ?) as case4 into :result'
execute s using :str_date1, :date_date2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case4;

-- 5 string_date - timestamp
prepare s from 'select datediff (?, ?) as case5 into :result'
execute s using :str_date1, :timestamp_timestamp2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case5;

-- 6 string_date - datetime
prepare s from 'select datediff (?, ?) as case6 into :result'
execute s using :str_date1, :datetime_datetime2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case6;

-- 7 string_timestamp - string_date
prepare s from 'select datediff (?, ?) as case7 into :result'
execute s using :str_timestamp1, :str_date2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case7;

-- 8 string_timestamp - string_timestamp
prepare s from 'select datediff (?, ?) as case8 into :result'
execute s using :str_timestamp1, :str_timestamp2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case8;

-- 9 string_timestamp - string_datetime
prepare s from 'select datediff (?, ?) as case9 into :result'
execute s using :str_timestamp1, :str_datetime2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case9;

-- 10 string_timestamp - date
prepare s from 'select datediff (?, ?) as case10 into :result'
execute s using :str_timestamp1, :str_date2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case10;

-- 11 string_timestamp - timestamp
prepare s from 'select datediff (?, ?) as case11 into :result'
execute s using :str_timestamp1, :str_timestamp2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case11;

-- 12 string_timestamp - datetime
prepare s from 'select datediff (?, ?) as case12 into :result'
execute s using :str_timestamp1, :str_datetime2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case12;

-- 13 string_datetime - string_date
prepare s from 'select datediff (?, ?) as case13 into :result'
execute s using :str_datetime1, :str_date2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case13;

-- 14 string_datetime - string_timestamp
prepare s from 'select datediff (?, ?) as case14 into :result'
execute s using :str_datetime1, :str_timestamp2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case14;

-- 15 string_datetime - string_datetime
prepare s from 'select datediff (?, ?) as case15 into :result'
execute s using :str_datetime1, :str_datetime2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case15;

-- 16 string_datetime - date
prepare s from 'select datediff (?, ?) as case16 into :result'
execute s using :str_datetime1, :date_date2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case16;

-- 17 string_datetime - timestamp
prepare s from 'select datediff (?, ?) as case17 into :result'
execute s using :str_datetime1, :timestamp_timestamp2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case17;

-- 18 string_datetime - datetime
prepare s from 'select datediff (?, ?) as case18 into :result'
execute s using :str_datetime1, :datetime_datetime2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case18;

-- 19 date - string_date
prepare s from 'select datediff (?, ?) as case19 into :result'
execute s using :date_date1, :str_date2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case19;

-- 20 date - string_timestamp
prepare s from 'select datediff (?, ?) as case20 into :result'
execute s using :date_date1, :str_timestamp2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case20;

-- 21 date - string_datetime
prepare s from 'select datediff (?, ?) as case21 into :result'
execute s using :date_date1, :str_datetime2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case21;

-- 22 date - date
prepare s from 'select datediff (?, ?) as case22 into :result'
execute s using :date_date1, :date_date2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case22;

-- 23 date - timestamp
prepare s from 'select datediff (?, ?) as case23 into :result'
execute s using :date_date1, :timestamp_timestamp2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case23;

-- 24 date - datetime
prepare s from 'select datediff (?, ?) as case24 into :result'
execute s using :date_date1, :datetime_datetime2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case24;

-- 25 timestamp - string_date
prepare s from 'select datediff (?, ?) as case25 into :result'
execute s using :timestamp_timestamp1, :str_date2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case25;

-- 26 timestamp - string_timestamp
prepare s from 'select datediff (?, ?) as case26 into :result'
execute s using :timestamp_timestamp1, :str_timestamp2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case26;

-- 27 timestamp - string_datetime
prepare s from 'select datediff (?, ?) as case27 into :result'
execute s using :timestamp_timestamp1, :str_datetime2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case27;

-- 28 timestamp - date
prepare s from 'select datediff (?, ?) as case28 into :result'
execute s using :timestamp_timestamp1, :date_date2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case28;

-- 29 timestamp - timestamp
prepare s from 'select datediff (?, ?) as case29 into :result'
execute s using :timestamp_timestamp1, :timestamp_timestamp2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case29;

-- 30 timestamp - datetime
prepare s from 'select datediff (?, ?) as case30 into :result'
execute s using :timestamp_timestamp1, :datetime_datetime2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case30;

-- 31 datetime - string_date
prepare s from 'select datediff (?, ?) as case31 into :result'
execute s using :datetime_datetime1, :str_date2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case31;

-- 32 datetime - string_timestamp
prepare s from 'select datediff (?, ?) as case32 into :result'
execute s using :datetime_datetime1, :str_timestamp2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case32;

-- 33 datetime - string_datetime
prepare s from 'select datediff (?, ?) as case33 into :result'
execute s using :datetime_datetime1, :str_datetime2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case33;

-- 34 datetime - date
prepare s from 'select datediff (?, ?) as case34 into :result'
execute s using :datetime_datetime1, :date_date2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case34;

-- 35 datetime - timestamp
prepare s from 'select datediff (?, ?) as case35 into :result'
execute s using :datetime_datetime1, :timestamp_timestamp2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case35;

-- 36 datetime - datetime
prepare s from 'select datediff (?, ?) as case36 into :result'
execute s using :datetime_datetime1, :datetime_datetime2
deallocate prepare s;

evaluate 6 into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case36;


--+ holdcas off;
