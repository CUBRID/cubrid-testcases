
----- minus constant folding

select datetime'2001-10-11 11:12:13' - 100000000000;

select datetimetz'2001-10-11 11:12:13' - 100000000000;

select 100000000000000 - datetime'2001-10-11 11:12:13';


---- query execution

create table t (i int, dtz datetimetz);
insert into t values (1, '2001-10-31 02:03:04 AM Europe/Bucharest EET');
insert into t values (2, '2001-10-11 02:03:04 AM Europe/Bucharest EEST');

insert into t values (3, '2002-10-27 01:30:00 AM America/Detroit');

insert into t values (4, '2002-10-27 01:30:00 AM America/Detroit EST');
insert into t values (5, '2002-10-27 01:30:00 AM America/Detroit EDT');

insert into t values (6, '1994-01-01 00:00:00 AM America/Lima -05');
--BUG: CUBRIDSUS-17099
insert into t values (7, '1993-12-31 23:59:59 PM America/Lima -05');
insert into t values (8, '1994-01-01 00:00:00 AM America/Lima -04');

insert into t values (9, '1996-01-01 00:00:00 AM America/Lima -05');
insert into t values (11, '1996-01-01 00:00:00 AM America/Lima -04');

select * from t order by i;


alter table t add dt datetime;
update t set dt=dtz;

alter table t add dtlz datetimeltz;
update t set dtlz=dtz;

alter t add ts timestamp;
update t set ts=dt;

alter t add tstz timestamptz;
update t set tstz=dt;

alter t add tstz2 timestamptz;
update t set tstz2=dtz;

alter t add tsltz timestampltz;
update t set tsltz=dtz;

select dt, ts, dt - ts, ts - dt from t order by i;

select dtz, ts, dtz - ts, ts - dtz from t  order by i;

select dtz, tstz, dtz - tstz, tstz - dtz from t  order by i;

select dtz, tstz2, dtz - tstz2, tstz2 - dtz from t  order by i;

select dtz, tsltz, dtz - tsltz, tsltz - dtz from t  order by i;

select dtz, dt, dtz - dt, dt - dtz from t  order by i;

select dtz, dtlz, dtz - dtlz, dtlz - dtz from t order by i;


select dtz, dtz + 10 from t  order by i;

-- 1 day
select dtz, dtz + 1 * 24 * 3600 * 1000 from t  order by i;

-- 30 days
select dtz, dtz + 20 * 24 * 3600 * 1000 from t  order by i;

select dtz, dtz - 20 * 24 * 3600 * 1000 from t  order by i;


alter table t add bi bigint;
update t set bi = -9223372036854775808;


update t set bi = 31536000000;
select dt, dt - bi from t  order by i;

select dtz, dtz + bi from t  order by i;

select dtz, dtz - 100 * bi from t  order by i;
select dtz, dtz - (100 * bi +  360000000) from t  order by i;


select tstz, bi, bi + tstz from t  order by i;

select tstz, bi, tstz + bi from t order by i;

select dtz, bi, bi + dtz from t order by i;

select dtz, bi, dtz + bi from t order by i;

alter table t add sh1 short;
update t set sh1 = 1;

select tstz, sh1, sh1 + tstz from t order by i;

select tstz, sh1, tstz + sh1 from t order by i;

select dtz, sh1, sh1 + dtz from t order by i;

select dtz, sh1, dtz + sh1 from t order by i;

drop t;
