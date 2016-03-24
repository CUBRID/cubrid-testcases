evaluate '05/26/2010' into :str_date;
evaluate '11:11:11 AM' into :str_time;
evaluate '11:11:11 AM 05/26/2010' into :str_timestamp;
evaluate '11:11:11.123 AM 05/26/2010' into :str_datetime;

evaluate cast('05/26/2010' as date) into :date_date;
evaluate cast('11:11:11 AM' as time) into :time_time;
evaluate cast('11:11:11 AM 05/26/2010' as timestamp) into :timestamp_timestamp;
evaluate cast('11:11:11.123 AM 05/26/2010' as datetime) into :datetime_datetime;

-- date_add string
-- 1
prepare s from 'select date_add (?, INTERVAL ? DAY) as case1 into :result'
execute s using :str_date, 1
deallocate prepare s;

evaluate '05/27/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

-- 2
prepare s from 'select date_add (?, INTERVAL ? HOUR) as case2 into :result'
execute s using :str_time, 1
deallocate prepare s;

-- 3
prepare s from 'select date_add (?, INTERVAL ? DAY) as case3 into :result'
execute s using :str_timestamp, 1
deallocate prepare s;

evaluate '11:11:11.000 AM 05/27/2010' into expected;
select case when :expected = :result then 'YES' else 'NO' end as case3;

-- 4
prepare s from 'select date_add (?, INTERVAL ? DAY) as case4 into :result'
execute s using :str_datetime, 1
deallocate prepare s;

evaluate '11:11:11.123 AM 05/27/2010' into expected;
select case when :expected = :result then 'YES' else 'NO' end as case4;

-- date_add date, time, timestamp, datetime
-- 5
prepare s from 'select date_add (?, INTERVAL ? DAY) as case5 into :result'
execute s using :date_date, 1
deallocate prepare s;

evaluate '05/27/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case5;

-- 6
prepare s from 'select date_add (?, INTERVAL ? HOUR) as case6 into :result'
execute s using :time_time, 1
deallocate prepare s;

-- 7
prepare s from 'select date_add (?, INTERVAL ? DAY) as case7 into :result'
execute s using :timestamp_timestamp, 1
deallocate prepare s;

evaluate '11:11:11.000 AM 05/27/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case7;

-- 8
prepare s from 'select date_add (?, INTERVAL ? DAY) as case8 into :result'
execute s using :datetime_datetime, 1
deallocate prepare s;

evaluate '11:11:11.123 AM 05/27/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case8;


-- adddate string
-- 9
prepare s from 'select adddate (?, ?) as case9 into :result'
execute s using :str_date, 1
deallocate prepare s;

evaluate '05/27/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case9;

-- 10
prepare s from 'select adddate (?, ?) as case10 into :result'
execute s using :str_time, 1
deallocate prepare s;

-- 11
prepare s from 'select adddate (?, ?) as case11 into :result'
execute s using :str_timestamp, 1
deallocate prepare s;

evaluate '11:11:11.000 AM 05/27/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case11;

-- 12
prepare s from 'select adddate (?, ?) as case12 into :result'
execute s using :str_datetime, 1
deallocate prepare s;

evaluate '11:11:11.123 AM 05/27/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case12;


-- adddate date, time, timestamp, datetime
-- 13
prepare s from 'select adddate (?, ?) as case13 into :result'
execute s using :date_date, 1
deallocate prepare s;

evaluate '05/27/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case13;

-- 14
prepare s from 'select adddate (?, ?) as case14 into :result'
execute s using :time_time, 1
deallocate prepare s;

-- 15
prepare s from 'select adddate (?, ?) as case15 into :result'
execute s using :timestamp_timestamp, 1
deallocate prepare s;

evaluate '11:11:11.000 AM 05/27/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case15;

-- 16
prepare s from 'select adddate (?, ?) as case16 into :result'
execute s using :datetime_datetime, 1
deallocate prepare s;

evaluate '11:11:11.123 AM 05/27/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case16;


-- date_sub string
-- 17
prepare s from 'select date_sub (?, INTERVAL ? DAY) as case17 into :result'
execute s using :str_date, 1
deallocate prepare s;

evaluate '05/25/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case17;

-- 18
prepare s from 'select date_sub (?, INTERVAL ? HOUR) as case18 into :result'
execute s using :str_time, 1
deallocate prepare s;

-- 19
prepare s from 'select date_sub (?, INTERVAL ? DAY) as case19 into :result'
execute s using :str_timestamp, 1
deallocate prepare s;

evaluate '11:11:11.000 AM 05/25/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case19;

-- 20
prepare s from 'select date_sub (?, INTERVAL ? DAY) as case20 into :result'
execute s using :str_datetime, 1
deallocate prepare s;

evaluate '11:11:11.123 AM 05/25/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case20;

-- subdate date, time, timestamp, datetime
-- 21
prepare s from 'select date_sub (?, INTERVAL ? DAY) as case21 into :result'
execute s using :date_date, 1
deallocate prepare s;

evaluate '05/25/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case21;

-- 22
prepare s from 'select date_sub (?, INTERVAL ? HOUR) as case22 into :result'
execute s using :time_time, 1
deallocate prepare s;

-- 23
prepare s from 'select date_sub (?, INTERVAL ? DAY) as case23 into :result'
execute s using :timestamp_timestamp, 1
deallocate prepare s;

evaluate '11:11:11.000 AM 05/25/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case23;

-- 24
prepare s from 'select date_sub (?, INTERVAL ? DAY) as case24 into :result'
execute s using :datetime_datetime, 1
deallocate prepare s;

evaluate '11:11:11.123 AM 05/25/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case24;


-- subdate string
-- 25
prepare s from 'select subdate (?, ?) as case25 into :result'
execute s using :str_date, 1
deallocate prepare s;

evaluate '05/25/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case25;

-- 26
prepare s from 'select subdate (?, ?) as case26 into :result'
execute s using :str_time, 1
deallocate prepare s;

-- 27
prepare s from 'select subdate (?, ?) as case27 into :result'
execute s using :str_timestamp, 1
deallocate prepare s;

evaluate '11:11:11.000 AM 05/25/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case27;

-- 28
prepare s from 'select subdate (?, ?) as case28 into :result'
execute s using :str_datetime, 1
deallocate prepare s;

evaluate '11:11:11.123 AM 05/25/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case28;

-- subdate date, time, timestamp, datetime
-- 29
prepare s from 'select subdate (?, ?) as case29 into :result'
execute s using :date_date, 1
deallocate prepare s;

evaluate '05/25/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case29;

-- 30
prepare s from 'select subdate (?, ?) as case30 into :result'
execute s using :time_time, 1
deallocate prepare s;

-- 31
prepare s from 'select subdate (?, ?) as case31 into :result'
execute s using :timestamp_timestamp, 1
deallocate prepare s;

evaluate '11:11:11.000 AM 05/25/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case31;

-- 32
prepare s from 'select subdate (?, ?) as case32 into :result'
execute s using :datetime_datetime, 1
deallocate prepare s;

evaluate '11:11:11.123 AM 05/25/2010' into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case32;

-- 33
prepare s from 'select date_add (?, INTERVAL ? DAY) as case33 into :result'
execute s using null, 1
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case33;

-- 34
prepare s from 'select date_add (?, INTERVAL ? DAY) as case34 into :result'
execute s using :date_date, null
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case34;

-- 35
prepare s from 'select date_add (?, INTERVAL ? DAY) as case35 into :result'
execute s using null, null
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case35;

-- 36
prepare s from 'select date_sub (?, INTERVAL ? DAY) as case36 into :result'
execute s using null, 1
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case36;

-- 37
prepare s from 'select date_sub (?, INTERVAL ? DAY) as case37 into :result'
execute s using :date_date, null
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case37;

-- 38
prepare s from 'select date_sub (?, INTERVAL ? DAY) as case38 into :result'
execute s using null, null
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case38;

-- 39
prepare s from 'select adddate (?, ?) as case39 into :result'
execute s using null, 1
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case39;

-- 40
prepare s from 'select adddate (?, ?) as case40 into :result'
execute s using :date_date, null
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case40;

-- 41
prepare s from 'select adddate (?, ?) as case41 into :result'
execute s using null, null
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case41;

-- 42
prepare s from 'select subdate (?, ?) as case42 into :result'
execute s using null, 1
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case42;

-- 42
prepare s from 'select subdate (?, ?) as case42 into :result'
execute s using :date_date, null
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case42;

-- 42
prepare s from 'select subdate (?, ?) as case42 into :result'
execute s using null, null
deallocate prepare s;

evaluate null into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case42;
