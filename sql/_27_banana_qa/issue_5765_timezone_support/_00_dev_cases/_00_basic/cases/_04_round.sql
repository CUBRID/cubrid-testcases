
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
select ts, ts_tz, ts_ltz, round (ts, 'yyyy'), round (ts_tz, 'yyyy'), round (ts_ltz, 'yyyy') from t order by 1;
select dt, dt_tz, dt_ltz, round (dt, 'yyyy'), round (dt_tz, 'yyyy'), round (dt_ltz, 'yyyy') from t order by 1;


-- year yy
select ts, ts_tz, ts_ltz, round (ts, 'yy'), round (ts_tz, 'yy'), round (ts_ltz, 'yy') from t order by 1;
select dt, dt_tz, dt_ltz, round (dt, 'yy'), round (dt_tz, 'yy'), round (dt_ltz, 'yy') from t order by 1;


-- month
select ts, ts_tz, ts_ltz, round (ts, 'mm'), round (ts_tz, 'mm'), round (ts_ltz, 'mm') from t order by 1;
select dt, dt_tz, dt_ltz, round (dt, 'mm'), round (dt_tz, 'mm'), round (dt_ltz, 'mm') from t order by 1;


-- quarter
select ts, ts_tz, ts_ltz, round (ts, 'q'), round (ts_tz, 'q'), round (ts_ltz, 'q') from t order by 1;
select dt, dt_tz, dt_ltz, round (dt, 'q'), round (dt_tz, 'q'), round (dt_ltz, 'q') from t order by 1;

-- day
select ts, ts_tz, ts_ltz, round (ts, 'day'), round (ts_tz, 'day'), round (ts_ltz, 'day') from t order by 1;
select dt, dt_tz, dt_ltz, round (dt, 'day'), round (dt_tz, 'day'), round (dt_ltz, 'day') from t order by 1;

-- dd
select ts, ts_tz, ts_ltz, round (ts, 'dd'), round (ts_tz, 'dd'), round (ts_ltz, 'dd') from t order by 1;
select dt, dt_tz, dt_ltz, round (dt, 'dd'), round (dt_tz, 'dd'), round (dt_ltz, 'dd') from t order by 1;

-- hh
select ts, ts_tz, ts_ltz, round (ts, 'hh'), round (ts_tz, 'hh'), round (ts_ltz, 'hh') from t order by 1;
select dt, dt_tz, dt_ltz, round (dt, 'hh'), round (dt_tz, 'hh'), round (dt_ltz, 'hh') from t order by 1;

-- mi
select ts, ts_tz, ts_ltz, round (ts, 'mi'), round (ts_tz, 'mi'), round (ts_ltz, 'mi') from t order by 1;
select dt, dt_tz, dt_ltz, round (dt, 'mi'), round (dt_tz, 'mi'), round (dt_ltz, 'mi') from t order by 1;


-- ss
select ts, ts_tz, ts_ltz, round (ts, 'ss'), round (ts_tz, 'ss'), round (ts_ltz, 'ss') from t order by 1;
select dt, dt_tz, dt_ltz, round (dt, 'ss'), round (dt_tz, 'ss'), round (dt_ltz, 'ss') from t order by 1;

drop table t;


