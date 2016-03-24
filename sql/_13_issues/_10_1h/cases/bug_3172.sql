-- string
select timestamp ('05/26/2010') as case1;
select timestamp ('11:11:11 AM 05/26/2010') as case2;
select timestamp ('11:01:11.123 AM 05/26/2010') as case3;

-- date, timestamp, datetime
select timestamp (cast ('05/26/2010' as date)) as case4;
select timestamp (cast ('11:11:11 AM 05/26/2010' as timestamp)) as case5;
select timestamp (cast ('11:01:11.123 AM 05/26/2010' as datetime)) as case6;

-- string + string
select timestamp ('05/26/2010', '01:00:00') as case7;
select timestamp ('11:11:11 AM 05/26/2010', '01:00:00') as case8;
select timestamp ('11:01:11.123 AM 05/26/2010', '01:00:00') as case9;

-- date, timestamp, datetime + string
select timestamp (cast ('05/26/2010' as date), '01:00:00') as case10;
select timestamp (cast ('11:11:11 AM 05/26/2010' as timestamp), '01:00:00') as case11;
select timestamp (cast ('11:01:11.123 AM 05/26/2010' as datetime), '01:00:00') as case12;

-- string + time
select timestamp ('05/26/2010', cast('01:00:00' as time)) as case13;
select timestamp ('11:11:11 AM 05/26/2010', cast('01:00:00' as time)) as case14;
select timestamp ('11:01:11.123 AM 05/26/2010', cast('01:00:00' as time)) as case15;

-- date, timestamp, datetime + time
select timestamp (cast ('05/26/2010' as date), cast('01:00:00' as time)) as case16;
select timestamp (cast ('11:11:11 AM 05/26/2010' as timestamp), cast('01:00:00' as time)) as case17;
select timestamp (cast ('11:01:11.123 AM 05/26/2010' as datetime), cast('01:00:00' as time)) as case18;
