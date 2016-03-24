evaluate '05/26/2010' into :str_date;
evaluate '11:11:11 AM 05/26/2010' into :str_timestamp;
evaluate '11:01:11.123 AM 05/26/2010' into :str_datetime;

evaluate date'05/26/2010' into :d_date;
evaluate timestamp'11:11:11 AM 05/26/2010' into :ts_timestamp;
evaluate datetime'11:01:11.123 AM 05/26/2010' into :dt_datetime;

evaluate '01:00:00' into :str_interval;
evaluate '01:00:00' into :time_interval;

-- str_date
prepare s from 'select timestamp(?) into :result' 
execute s using :str_date
deallocate prepare s;

select timestamp (:str_date) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

-- str_timestamp
prepare s from 'select timestamp(?) into :result' 
execute s using :str_timestamp
deallocate prepare s;

select timestamp (:str_timestamp) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case2;

-- str_datetime
prepare s from 'select timestamp(?) into :result' 
execute s using :str_datetime
deallocate prepare s;

select timestamp (:str_datetime) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case3;

-- d_date
prepare s from 'select timestamp(?) into :result' 
execute s using :d_date
deallocate prepare s;

select timestamp (:d_date) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case4;

-- ts_timestamp
prepare s from 'select timestamp(?) into :result' 
execute s using :ts_timestamp
deallocate prepare s;

select timestamp (:ts_timestamp) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case5;

-- dt_datetime
prepare s from 'select timestamp(?) into :result' 
execute s using :dt_datetime
deallocate prepare s;

select timestamp (:dt_datetime) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case6;

-- str_date + str
prepare s from 'select timestamp(?, ?) into :result' 
execute s using :str_date, :str_interval
deallocate prepare s;

select timestamp (:str_date, :str_interval) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case7;

-- str_timestamp + str
prepare s from 'select timestamp(?, ?) into :result' 
execute s using :str_timestamp, :str_interval
deallocate prepare s;

select timestamp (:str_timestamp, :str_interval) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case8;

-- str_datetime + str
prepare s from 'select timestamp(?, ?) into :result' 
execute s using :str_datetime, :str_interval
deallocate prepare s;

select timestamp (:str_datetime, :str_interval) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case9;

-- d_date + str
prepare s from 'select timestamp(?, ?) into :result' 
execute s using :d_date, :str_interval
deallocate prepare s;

select timestamp (:d_date, :str_interval) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case10;

-- ts_timestamp + str
prepare s from 'select timestamp(?, ?) into :result' 
execute s using :ts_timestamp, :str_interval
deallocate prepare s;

select timestamp (:ts_timestamp, :str_interval) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case11;

-- dt_datetime + str
prepare s from 'select timestamp(?, ?) into :result' 
execute s using :dt_datetime, :str_interval
deallocate prepare s;

select timestamp (:dt_datetime, :str_interval) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case12;

-- str_date + time
prepare s from 'select timestamp(?, ?) into :result' 
execute s using :str_date, :time_interval
deallocate prepare s;

select timestamp (:str_date, :time_interval) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case13;

-- str_timestamp + time
prepare s from 'select timestamp(?, ?) into :result' 
execute s using :str_timestamp, :time_interval
deallocate prepare s;

select timestamp (:str_timestamp, :time_interval) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case14;

-- str_datetime + time
prepare s from 'select timestamp(?, ?) into :result' 
execute s using :str_datetime, :time_interval
deallocate prepare s;

select timestamp (:str_datetime, :time_interval) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case15;

-- d_date + time
prepare s from 'select timestamp(?, ?) into :result' 
execute s using :d_date, :time_interval
deallocate prepare s;

select timestamp (:d_date, :time_interval) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case16;

-- ts_timestamp + time
prepare s from 'select timestamp(?, ?) into :result' 
execute s using :ts_timestamp, :time_interval
deallocate prepare s;

select timestamp (:ts_timestamp, :time_interval) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case17;

-- dt_datetime + time
prepare s from 'select timestamp(?, ?) into :result' 
execute s using :dt_datetime, :time_interval
deallocate prepare s;

select timestamp (:dt_datetime, :time_interval) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case18;
