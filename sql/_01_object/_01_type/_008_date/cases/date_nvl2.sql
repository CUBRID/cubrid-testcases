

-- datetime, other

select nvl2(datetime'01/01/2000', datetime'01/03/2000', datetime'01/02/2000');

select nvl2(datetime'01/01/2000', timestamp'01/03/2000', timestamp'01/02/2000');

select nvl2(datetime'01/01/2000', date'01/03/2000', date'01/02/2000');

select nvl2(datetime'01/01/2000', time'00:00:01', time'00:00:00');

select nvl2(datetime'01/01/2000', '01/03/2000 00:00:01.000', '01/02/2000 00:00:00.000');

select nvl2(datetime'01/01/2000', '01/03/2000 00:00:01', '01/02/2000 00:00:00');

select nvl2(datetime'01/01/2000', '01/03/2000', '01/02/2000');

select nvl2(datetime'01/01/2000', '00:00:01', '00:00:00');


-- timestamp, other

select nvl2(timestamp'01/01/2000', datetime'01/03/2000', datetime'01/02/2000');

select nvl2(timestamp'01/01/2000', timestamp'01/03/2000', timestamp'01/02/2000');

select nvl2(timestamp'01/01/2000', date'01/03/2000', date'01/02/2000');

select nvl2(timestamp'01/01/2000', time'00:00:01', time'00:00:00');

select nvl2(timestamp'01/01/2000', '01/03/2000 00:00:01.000', '01/02/2000 00:00:00.000');

select nvl2(timestamp'01/01/2000', '01/03/2000 00:00:01', '01/02/2000 00:00:00');

select nvl2(timestamp'01/01/2000', '01/03/2000', '01/02/2000');

select nvl2(timestamp'01/01/2000', '00:00:01', '00:00:00');


-- date, other

select nvl2(date'01/01/2000', datetime'01/03/2000', datetime'01/02/2000');

select nvl2(date'01/01/2000', timestamp'01/03/2000', timestamp'01/02/2000');

select nvl2(date'01/01/2000', date'01/03/2000', date'01/02/2000');

select nvl2(date'01/01/2000', time'00:00:01', time'00:00:00');

select nvl2(date'01/01/2000', '01/03/2000 00:00:01.000', '01/02/2000 00:00:00.000');

select nvl2(date'01/01/2000', '01/03/2000 00:00:01', '01/02/2000 00:00:00');

select nvl2(date'01/01/2000', '01/03/2000', '01/02/2000');

select nvl2(date'01/01/2000', '00:00:01', '00:00:00');


-- time, other

select nvl2(time'00:00:00', datetime'01/03/2000', datetime'01/02/2000');

select nvl2(time'00:00:00', timestamp'01/03/2000', timestamp'01/02/2000');

select nvl2(time'00:00:00', date'01/03/2000', date'01/02/2000');

select nvl2(time'00:00:00', time'00:00:00', time'00:00:01');

select nvl2(time'00:00:00', '01/03/2000 00:00:00.000', '01/02/2000 00:00:01.000');

select nvl2(time'00:00:00', '01/03/2000 00:00:00', '01/02/2000 00:00:01');

select nvl2(time'00:00:00', '01/03/2000', '01/02/2000');

select nvl2(time'00:00:00', '00:00:00', '00:00:01');



create table t1 (c_dt datetime, c_ts timestamp, c_d date, c_t time)
insert into t1 values(null, null, null, null);

select nvl2(c_dt, datetime'01/03/2000', datetime'01/02/2000') from t1;

select nvl2(c_dt, timestamp'01/03/2000', timestamp'01/02/2000') from t1;

select nvl2(c_dt, date'01/03/2000', date'01/02/2000') from t1;

select nvl2(c_dt, time'00:00:01', time'00:00:00') from t1;

select nvl2(c_dt, '01/03/2000 00:00:01.000', '01/02/2000 00:00:00.000') from t1;

select nvl2(c_dt, '01/03/2000 00:00:01', '01/02/2000 00:00:00') from t1;

select nvl2(c_dt, '01/03/2000', '01/02/2000') from t1;

select nvl2(c_dt, '00:00:01', '00:00:00') from t1;


select nvl2(c_ts, datetime'01/03/2000', datetime'01/02/2000') from t1;

select nvl2(c_ts, timestamp'01/03/2000', timestamp'01/02/2000') from t1;

select nvl2(c_ts, date'01/03/2000', date'01/02/2000') from t1;

select nvl2(c_ts, time'00:00:01', time'00:00:00') from t1;

select nvl2(c_ts, '01/03/2000 00:00:01.000', '01/02/2000 00:00:00.000') from t1;

select nvl2(c_ts, '01/03/2000 00:00:01', '01/02/2000 00:00:00') from t1;

select nvl2(c_ts, '01/03/2000', '01/02/2000') from t1;

select nvl2(c_ts, '00:00:01', '00:00:00') from t1;


select nvl2(c_d, datetime'01/03/2000', datetime'01/02/2000') from t1;

select nvl2(c_d, timestamp'01/03/2000', timestamp'01/02/2000') from t1;

select nvl2(c_d, date'01/03/2000', date'01/02/2000') from t1;

select nvl2(c_d, time'00:00:01', time'00:00:00') from t1;

select nvl2(c_d, '01/03/2000 00:00:01.000', '01/02/2000 00:00:00.000') from t1;

select nvl2(c_d, '01/03/2000 00:00:01', '01/02/2000 00:00:00') from t1;

select nvl2(c_d, '01/03/2000', '01/02/2000') from t1;

select nvl2(c_d, '00:00:01', '00:00:00') from t1;


select nvl2(c_t, datetime'01/03/2000', datetime'01/02/2000') from t1;

select nvl2(c_t, timestamp'01/03/2000', timestamp'01/02/2000') from t1;

select nvl2(c_t, date'01/03/2000', date'01/02/2000') from t1;

select nvl2(c_t, time'00:00:01', time'00:00:00') from t1;

select nvl2(c_t, '01/03/2000 00:00:01.000', '01/02/2000 00:00:00.000') from t1;

select nvl2(c_t, '01/03/2000 00:00:01', '01/02/2000 00:00:00') from t1;

select nvl2(c_t, '01/03/2000', '01/02/2000') from t1;

select nvl2(c_t, '00:00:01', '00:00:00') from t1;


drop t1;




