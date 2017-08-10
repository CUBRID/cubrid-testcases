--test with prepared statements

create table trunc_ps(
	id int primary key auto_increment,
	str varchar not null,
	dt date,
	ts timestamp default current_timestamp,
	dtime datetime default sysdatetime
);


insert into trunc_ps(str, dt, ts, dtime) values('aaa', '1990-12-1', '2000-09-01 12:12:12', '2010-07-01 12:12:12.123');
insert into trunc_ps(str, dt, ts, dtime) values('aaa', '1991-12-1', '2001-09-18 12:12:12', '2011-07-01 12:12:12.123');
insert into trunc_ps(str, dt, ts, dtime) values('aaa', '1992-12-1', '2002-09-01 12:12:12', '2012-07-20 12:12:12.123');
insert into trunc_ps(str, dt, ts, dtime) values('bbb', '1990-12-31', '2000-09-01 12:12:12', '2010-07-01 12:12:12.123');
insert into trunc_ps(str, dt, ts, dtime) values('bbb', '1993-12-1', '2003-09-16 12:12:12', '2023-07-01 12:12:12.123');
insert into trunc_ps(str, dt, ts, dtime) values('bbb', '1994-12-1', '2004-09-01 12:12:12', '2024-07-31 12:12:12.123');
insert into trunc_ps(str, dt, ts, dtime) values('ccc', '1990-12-1', '2000-09-01 12:12:12', '2027-07-01 12:12:12.123');
insert into trunc_ps(str, dt, ts, dtime) values('ccc', '1997-12-31', '2007-09-15 12:12:12', '2028-07-01 12:12:12.123');
insert into trunc_ps(str, dt, ts, dtime) values('ccc', '1998-12-1', '2008-09-01 12:12:12', '2010-07-16 12:12:12.123');
insert into trunc_ps(str, dt, ts, dtime) values('ddd', '1990-12-1', '2000-09-01 12:12:12', '2010-07-01 12:12:12.123');
insert into trunc_ps(str, dt, ts, dtime) values('ddd', '1999-12-29', '2009-09-01 12:12:12', '2029-07-01 12:12:12.123');
insert into trunc_ps(str, dt, ts, dtime) values('ddd', '1999-12-1', '2009-09-01 12:12:12', '2029-07-14 12:12:12.123');


prepare st from 'select id, str, dt, trunc(dt) from trunc_ps where trunc(dt) < ? and trunc(ts) > ? order by 1';
execute st using '1994-12-12', '2002-1-1';

prepare st from 'select id, str, dtime, trunc(dtime) from trunc_ps where trunc(dtime, ?) between trunc(?) and trunc(?) order by 1';
execute st using 'dd', date'2012-1-1', date'2018-12-12';

prepare st from 'select id, str, dt, ts, trunc(ts) from trunc_ps where dt in (trunc(?), trunc(?)) order by 1';
execute st using date'1990-12-31', date'12/15/1994';

prepare st from 'select 1 from (select id, str, dt, trunc(ts), trunc(dtime) from trunc_ps where dtime >= trunc(sysdatetime) or ts between trunc(?) and (trunc(?) + 1)) order by 1';
execute st using date'2008-10-25', timestamp'2013-12-12 11:11:11';

prepare st from 'select 100 from (select id, str, dt, trunc(ts), trunc(dtime) from trunc_ps where dt < trunc(sysdate) and ts between trunc(?) and (trunc(?) + 1)) order by 1';
execute st using date'2005-10-25', timestamp'2013-12-12 11:11:11';

prepare st from 'insert into trunc_ps(str, dt, ts, dtime) select str, trunc(?), trunc(ts), trunc(dtime) from trunc_ps where dt between trunc(?) and (trunc(?) -1) order by 1';
execute st using datetime'2013-12-12 11:11:11.999', date'1993-12-1', date'1998-1-1';

prepare st from 'insert into trunc_ps(str, dt) values(?, trunc(sysdate, ?))';
execute st using 'inserted', 'dd';

prepare st from 'select if(dt=sysdate, ?, ?) from trunc_ps where str=?;';
execute st using 'ok', 'nok', 'inserted';
deallocate prepare st;



drop table trunc_ps;
