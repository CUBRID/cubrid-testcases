--test ADDTIME()
select typeof (addtime('2010-01-01 12:00:01.001', time'00:00:01'));

select addtime(datetime'2010-01-01 12:00:00.001', time'00:00:01');

select addtime(time'12:00:01', time'00:00:01');

select addtime('12:00:01', '00:00:01');

select addtime('23:59:59', '00:00:01');

select addtime('00:00:00', '2010-01-01');

select addtime('2007-12-31 23:59:59.999999', '1 1:1:1.000002');

select addtime('1-1-1 00:00:00', '01:01:01');

select addtime('2010-01-01', '19:22:11');

select addtime(date'2010-01-01', time'19:22:11');

select addtime('2010-01-01', time'19:22:11');

select addtime(date'2010-01-01', '19:22:11');

create table a (d date, t time, tm timestamp, dt datetime, vdt varchar(32), vd varchar(32), vt varchar(32));

insert into a values('2010-01-01', '01:01:01', '2010-01-01 01:01:01', '2010-01-01 01:01:01.001','2010-01-01 01:01:01.001','2010-01-01','01:01:01');

select d,t, addtime(d,t), if(addtime(d,t) = datetime'2010-01-01 01:01:01', 'ok', 'nok') from a;

select t,t, addtime(t,t), if(addtime(t,t) = time'02:02:02', 'ok', 'nok') from a;

select tm,t , addtime(tm,t), if(addtime(tm,t) = datetime'2010-01-01 02:02:02', 'ok', 'nok') from a;

select dt,t , addtime(dt,t), if(addtime(dt,t) = datetime'2010-01-01 02:02:02.001', 'ok', 'nok') from a;

select  vdt, t, addtime(vdt, t), if(addtime(vdt, t) = datetime'2010-01-01 02:02:02.001', 'ok', 'nok') from a;

select  vd, t, addtime(vd, t), if(addtime(vd, t) = time'01:21:11', 'ok', 'nok') from a;

select  vt, t, addtime(vt, t), if(addtime(vt, t) = time'02:02:02', 'ok', 'nok') from a;

select d,d , addtime(d,d), if(addtime(d,d) = datetime'4020-01-02 00:00:00', 'ok', 'nok') from a;

select t,d , addtime(t,d), if(addtime(t,d) = NULL, 'ok', 'nok') from a;

select tm,d , addtime(tm,d), if(addtime(tm,d) = datetime'4020-01-02 01:01:01', 'ok', 'nok') from a;

select dt,d , addtime(dt,d), if(addtime(dt,d) = datetime'4020-01-02 01:01:01', 'ok', 'nok') from a;

select  vdt, d, addtime(vdt, d), if(addtime(vdt, d) = datetime'4020-01-02 01:01:01.001', 'ok', 'nok') from a;

select  vd, d, addtime(vd, d), if(addtime(vd, d) = time'00:20:11', 'ok', 'nok') from a;

select  vt, d, addtime(vt, d), if(addtime(vt, d) = time'01:01:02', 'ok', 'nok') from a;

select d,tm , addtime(d,tm), if(addtime(d,tm) = datetime'2010-01-01 01:01:01.000', 'ok', 'nok') from a;

select t,tm , addtime(t,tm), if(addtime(t,tm) = time'02:02:02', 'ok', 'nok') from a;

select tm,tm , addtime(tm,tm), if(addtime(tm,tm) = datetime'2010-01-01 02:02:02', 'ok', 'nok') from a;

select dt,tm , addtime(dt,tm), if(addtime(dt,tm) = datetime'2010-01-01 02:02:02.001', 'ok', 'nok') from a;

select  vdt, tm, addtime(vdt, tm), if(addtime(vdt, tm) = datetime'2010-01-01 02:02:02.001', 'ok', 'nok') from a;

select  vd, tm, addtime(vd, tm), if(addtime(vd, tm) =time'01:21:11', 'ok', 'nok') from a;

select  vt, tm, addtime(vt, tm), if(addtime(vt, tm) = time'02:02:02', 'ok', 'nok') from a;

select d,dt , addtime(d,dt), if(addtime(d,dt) = datetime'2010-01-01 01:01:01', 'ok', 'nok') from a;

select t,dt , addtime(t,dt), if(addtime(t,dt) = time'02:02:02', 'ok', 'nok') from a;

select tm,dt , addtime(tm,dt), if(addtime(tm,dt) = datetime'2010-01-01 02:02:02', 'ok', 'nok') from a;

select dt,dt , addtime(dt,dt), if(addtime(dt,dt) = datetime'2010-01-01 02:02:02.001', 'ok', 'nok') from a;

select  vdt, dt, addtime(vdt, dt), if(addtime(vdt, dt) = datetime'2010-01-01 02:02:02.001', 'ok', 'nok') from a;

select  vd, dt, addtime(vd, dt), if(addtime(vd, dt) = time'01:21:11', 'ok', 'nok') from a;

select  vt, dt, addtime(vt, dt), if(addtime(vt, dt) = time'02:02:02', 'ok', 'nok') from a;

select d,vdt , addtime(d,vdt), if(addtime(d,vdt) = time'01:01:02', 'ok', 'nok') from a;

select t,vdt , addtime(t,vdt), if(addtime(t,vdt) = time'02:02:02', 'ok', 'nok') from a;

select tm,vdt , addtime(tm,vdt), if(addtime(tm,vdt) = datetime'2010-01-01 02:02:02', 'ok', 'nok') from a;

select dt,vdt , addtime(dt,vdt), if(addtime(dt,vdt) = datetime'2010-01-01 02:02:02.001', 'ok', 'nok') from a;

select  vdt, vdt, addtime(vdt, vdt), if(addtime(vdt, vdt) = datetime'2010-01-01 02:02:02.001', 'ok', 'nok') from a;

select  vd, vdt, addtime(vd, vdt), if(addtime(vd, vdt) = time'01:21:11', 'ok', 'nok') from a;

select  vt, vdt, addtime(vt, vdt), if(addtime(vt, vdt) = time'02:02:02', 'ok', 'nok') from a;

select d,vd , addtime(d,vd), if(addtime(d,vd) = time'00:20:11', 'ok', 'nok') from a;

select t,vd , addtime(t,vd), if(addtime(t,vd) = time'01:21:11', 'ok', 'nok') from a;

select tm,vd , addtime(tm,vd), if(addtime(tm,vd) = datetime'2010-01-01 01:21:11', 'ok', 'nok') from a;

select dt,vd , addtime(dt,vd), if(addtime(dt,vd) = datetime'2010-01-01 01:21:11.001', 'ok', 'nok') from a;

select  vdt, vd, addtime(vdt, vd), if(addtime(vdt, vd) = datetime'2010-01-01 01:21:11.001', 'ok', 'nok') from a;

select  vd, vd, addtime(vd, vd), if(addtime(vd, vd) = time'00:40:20', 'ok', 'nok') from a;

select  vt, vd, addtime(vt, vd), if(addtime(vt, vd) = time'01:21:11', 'ok', 'nok') from a;

select d,vt , addtime(d,vt), if(addtime(d,vt) = time'01:01:02', 'ok', 'nok') from a;

select t,vt , addtime(t,vt), if(addtime(t,vt) = time'02:02:02', 'ok', 'nok') from a;

select tm,vt , addtime(tm,vt), if(addtime(tm,vt) = datetime'2010-01-01 02:02:02', 'ok', 'nok') from a;

select dt,vt , addtime(dt,vt), if(addtime(dt,vt) = datetime'2010-01-01 02:02:02.001', 'ok', 'nok') from a;

select  vdt, vt, addtime(vdt, vt), if(addtime(vdt, vt) = datetime'2010-01-01 02:02:02.001', 'ok', 'nok') from a;

select  vd, vt, addtime(vd, vt), if(addtime(vd, vt) = time'01:21:11', 'ok', 'nok') from a;

select  vt, vt, addtime(vt, vt), if(addtime(vt, vt) = time'02:02:02', 'ok', 'nok') from a;

drop table a;

$varchar, $2010-01-01 01:01:01, $varchar , $01:01:01
select addtime (?,?);

$datetime, $2010-01-01 01:01:01, $time, $01:01:01
select addtime(?,?);

$time, $01:01:01, $time, $01:01:01
select addtime(?,?);

$date, $2010-01-01, $time, $01:01:01
select addtime(?, ?);

$int, $2010, $time, $01:01:01
select addtime(?,?);