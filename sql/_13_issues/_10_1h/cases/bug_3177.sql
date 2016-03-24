evaluate '05/26/2010' into :str_date;
evaluate '11:11:11 AM' into :str_time;
evaluate '11:11:11 AM 05/26/2010' into :str_timestamp;
evaluate '11:11:11.123 AM 05/26/2010' into :str_datetime;

evaluate cast('05/26/2010' as date) into :date_date;
evaluate cast('11:11:11 AM' as time) into :time_time;
evaluate cast('11:11:11 AM 05/26/2010' as timestamp) into :timestamp_timestamp;
evaluate cast('11:11:11.123 AM 05/26/2010' as datetime) into :datetime_datetime;

-- date_add string
select date_add (:str_date, INTERVAL 1 DAY) as case1;
select date_add (:str_time, INTERVAL 1 HOUR) as case2;
select date_add (:str_timestamp, INTERVAL 1 DAY) as case3;
select date_add (:str_datetime, INTERVAL 1 DAY) as case4;

elect date_add (:date_date, INTERVAL 1 DAY) as case5;
select date_add (:time_time, INTERVAL 1 HOUR) as case6;
select date_add (:timestamp_timestamp, INTERVAL 1 DAY) as case7;
select date_add (:datetime_datetime, INTERVAL 1 DAY) as case8;

-- adddate string
select adddate (:str_date, 1) as case9;
select adddate (:str_time, 1) as case10;
select adddate (:str_timestamp, 1) as case11;
select adddate (:str_datetime, 1) as case12;

-- adddate date, time, timestamp, datetime
select adddate (:date_date, 1) as case13;
select adddate (:time_time, 1) as case14;
select adddate (:timestamp_timestamp, 1) as case15;
select adddate (:datetime_datetime, 1) as case16;

-- date_sub string
select date_sub (:str_date, INTERVAL 1 DAY) as case17;
select date_sub (:str_time, INTERVAL 1 HOUR) as case18;
select date_sub (:str_timestamp, INTERVAL 1 DAY) as case19;
select date_sub (:str_datetime, INTERVAL 1 DAY) as case20;

-- date_sub date, time, timestamp, datetime
select date_sub (:date_date, INTERVAL 1 DAY) as case21;
select date_sub (:time_time, INTERVAL 1 DAY) as case22;
select date_sub (:timestamp_timestamp, INTERVAL 1 DAY) as case23;
select date_sub (:datetime_datetime, INTERVAL 1 DAY) as case24;

-- subdate string
select subdate (:str_date, 1) as case25;
select subdate (:str_time, 1) as case26;
select subdate (:str_timestamp, 1) as case27;
select subdate (:str_datetime, 1) as case28;

-- subdate date, time, timestamp, datetime
select subdate (:date_date, 1) as case29;
select subdate (:time_time, 1) as case30;
select subdate (:timestamp_timestamp, 1) as case31;
select subdate (:datetime_datetime, 1) as case32;

-- date_add null
select date_add (null, interval 1 day);
select date_add (sysdate, interval null day);
select date_add (null, interval null day);

-- date_sub null
select date_sub (null, interval 1 day);
select date_sub (sysdate, interval null day);
select date_sub (null, interval null day);

-- adddate null
select adddate (null, 1);
select adddate (sysdate, null);
select adddate (null, null);

-- subdate null
select subdate (null, 1);
select subdate (sysdate, null);
select subdate (null, null);
