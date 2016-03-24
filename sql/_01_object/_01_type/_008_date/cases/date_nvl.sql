

-- datetime, other

select nvl(datetime'01/01/2000', datetime'01/02/2000');

select nvl(datetime'01/01/2000', timestamp'01/02/2000');

select nvl(datetime'01/01/2000', date'01/02/2000');

select nvl(datetime'01/01/2000', time'00:00:00');

select nvl(datetime'01/01/2000', '01/02/2000 00:00:00.000');

select nvl(datetime'01/01/2000', '01/02/2000 00:00:00');

select nvl(datetime'01/01/2000', '01/02/2000');

select nvl(datetime'01/01/2000', '00:00:00');


-- timestamp, other

select nvl(timestamp'01/01/2000', datetime'01/02/2000');

select nvl(timestamp'01/01/2000', timestamp'01/02/2000');

select nvl(timestamp'01/01/2000', date'01/02/2000');

select nvl(timestamp'01/01/2000', time'00:00:00');

select nvl(timestamp'01/01/2000', '01/02/2000 00:00:00.000');

select nvl(timestamp'01/01/2000', '01/02/2000 00:00:00');

select nvl(timestamp'01/01/2000', '01/02/2000');

select nvl(timestamp'01/01/2000', '00:00:00');


-- date, other

select nvl(date'01/01/2000', datetime'01/02/2000');

select nvl(date'01/01/2000', timestamp'01/02/2000');

select nvl(date'01/01/2000', date'01/02/2000');

select nvl(date'01/01/2000', time'00:00:00');

select nvl(date'01/01/2000', '01/02/2000 00:00:00.000');

select nvl(date'01/01/2000', '01/02/2000 00:00:00');

select nvl(date'01/01/2000', '01/02/2000');

select nvl(date'01/01/2000', '00:00:00');


-- time, other

select nvl(time'00:00:00', datetime'01/02/2000');

select nvl(time'00:00:00', timestamp'01/02/2000');

select nvl(time'00:00:00', date'01/02/2000');

select nvl(time'00:00:00', time'00:00:00');

select nvl(time'00:00:00', '01/02/2000 00:00:00.000');

select nvl(time'00:00:00', '01/02/2000 00:00:00');

select nvl(time'00:00:00', '01/02/2000');

select nvl(time'00:00:00', '00:00:00');



create table t1 (c_dt datetime, c_ts timestamp, c_d date, c_t time);
insert into t1 values(null, null, null, null);

select nvl(c_dt, datetime'01/02/2000') from t1;

select nvl(c_dt, timestamp'01/02/2000') from t1;

select nvl(c_dt, date'01/02/2000') from t1;

select nvl(c_dt, time'00:00:00') from t1;

select nvl(c_dt, '01/02/2000 00:00:00.000') from t1;

select nvl(c_dt, '01/02/2000 00:00:00') from t1;

select nvl(c_dt, '01/02/2000') from t1;

select nvl(c_dt, '00:00:00') from t1;


select nvl(c_ts, datetime'01/02/2000') from t1;

select nvl(c_ts, timestamp'01/02/2000') from t1;

select nvl(c_ts, date'01/02/2000') from t1;

select nvl(c_ts, time'00:00:00') from t1;

select nvl(c_ts, '01/02/2000 00:00:00.000') from t1;

select nvl(c_ts, '01/02/2000 00:00:00') from t1;

select nvl(c_ts, '01/02/2000') from t1;

select nvl(c_ts, '00:00:00') from t1;


select nvl(c_d, datetime'01/02/2000') from t1;

select nvl(c_d, timestamp'01/02/2000') from t1;

select nvl(c_d, date'01/02/2000') from t1;

select nvl(c_d, time'00:00:00') from t1;

select nvl(c_d, '01/02/2000 00:00:00.000') from t1;

select nvl(c_d, '01/02/2000 00:00:00') from t1;

select nvl(c_d, '01/02/2000') from t1;

select nvl(c_d, '00:00:00') from t1;


select nvl(c_t, datetime'01/02/2000') from t1;

select nvl(c_t, timestamp'01/02/2000') from t1;

select nvl(c_t, date'01/02/2000') from t1;

select nvl(c_t, time'00:00:00') from t1;

select nvl(c_t, '01/02/2000 00:00:00.000') from t1;

select nvl(c_t, '01/02/2000 00:00:00') from t1;

select nvl(c_t, '01/02/2000') from t1;

select nvl(c_t, '00:00:00') from t1;


drop t1;




