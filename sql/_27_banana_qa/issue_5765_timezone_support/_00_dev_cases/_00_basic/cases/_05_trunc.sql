
drop table if exists t;

create table t (ts_tz timestamptz);

insert into t values ('1996-02-03 02:03:04 AM America/Lima -05');


alter table t add ts timestamp;
update t set ts=ts_tz;

alter table t add ts_ltz timestampltz;
update t set ts_ltz=ts_tz;


alter table t add dt_ltz datetimeltz;
update t set dt_ltz=ts_tz;

alter table t add dt_tz datetimetz;
update t set dt_tz=ts_tz;

alter table t add dt datetime;
update t set dt=ts_tz;


-- year yyyy
select ts, ts_tz, ts_ltz, trunc (ts, 'yyyy'), trunc (ts_tz, 'yyyy'), trunc (ts_ltz, 'yyyy') from t order by 1;
select dt, dt_tz, dt_ltz, trunc (dt, 'yyyy'), trunc (dt_tz, 'yyyy'), trunc (dt_ltz, 'yyyy') from t order by 1;


-- year yy
select ts, ts_tz, ts_ltz, trunc (ts, 'yy'), trunc (ts_tz, 'yy'), trunc (ts_ltz, 'yy') from t order by 1;
select dt, dt_tz, dt_ltz, trunc (dt, 'yy'), trunc (dt_tz, 'yy'), trunc (dt_ltz, 'yy') from t order by 1;


-- month
select ts, ts_tz, ts_ltz, trunc (ts, 'mm'), trunc (ts_tz, 'mm'), trunc (ts_ltz, 'mm') from t order by 1;
select dt, dt_tz, dt_ltz, trunc (dt, 'mm'), trunc (dt_tz, 'mm'), trunc (dt_ltz, 'mm') from t order by 1;


-- quarter
select ts, ts_tz, ts_ltz, trunc (ts, 'q'), trunc (ts_tz, 'q'), trunc (ts_ltz, 'q') from t order by 1;
select dt, dt_tz, dt_ltz, trunc (dt, 'q'), trunc (dt_tz, 'q'), trunc (dt_ltz, 'q') from t order by 1;

-- day
select ts, ts_tz, ts_ltz, trunc (ts, 'day'), trunc (ts_tz, 'day'), trunc (ts_ltz, 'day') from t order by 1;
select dt, dt_tz, dt_ltz, trunc (dt, 'day'), trunc (dt_tz, 'day'), trunc (dt_ltz, 'day') from t order by 1;

-- dd
select ts, ts_tz, ts_ltz, trunc (ts, 'dd'), trunc (ts_tz, 'dd'), trunc (ts_ltz, 'dd') from t order by 1;
select dt, dt_tz, dt_ltz, trunc (dt, 'dd'), trunc (dt_tz, 'dd'), trunc (dt_ltz, 'dd') from t order by 1;

-- hh
select ts, ts_tz, ts_ltz, trunc (ts, 'hh'), trunc (ts_tz, 'hh'), trunc (ts_ltz, 'hh') from t order by 1;
select dt, dt_tz, dt_ltz, trunc (dt, 'hh'), trunc (dt_tz, 'hh'), trunc (dt_ltz, 'hh') from t order by 1;

-- mi
select ts, ts_tz, ts_ltz, trunc (ts, 'mi'), trunc (ts_tz, 'mi'), trunc (ts_ltz, 'mi') from t order by 1;
select dt, dt_tz, dt_ltz, trunc (dt, 'mi'), trunc (dt_tz, 'mi'), trunc (dt_ltz, 'mi') from t order by 1;


-- ss
select ts, ts_tz, ts_ltz, trunc (ts, 'ss'), trunc (ts_tz, 'ss'), trunc (ts_ltz, 'ss') from t order by 1;
select dt, dt_tz, dt_ltz, trunc (dt, 'ss'), trunc (dt_tz, 'ss'), trunc (dt_ltz, 'ss') from t order by 1;

drop table t;


