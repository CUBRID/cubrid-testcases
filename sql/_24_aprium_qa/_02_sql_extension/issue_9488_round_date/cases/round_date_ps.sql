--test with prepared statements
--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

create table round_ps(
	id int primary key auto_increment,
	str varchar not null,
	dt date,
	ts timestamp default current_timestamp,
	dtime datetime default sysdatetime
);


insert into round_ps(str, dt, ts, dtime) values('aaa', '1990-12-1', '2000-09-01 12:12:12', '2010-07-01 12:12:12.123');
insert into round_ps(str, dt, ts, dtime) values('aaa', '1991-12-1', '2001-09-18 12:12:12', '2011-07-01 12:12:12.123');
insert into round_ps(str, dt, ts, dtime) values('aaa', '1992-12-1', '2002-09-01 12:12:12', '2012-07-20 12:12:12.123');
insert into round_ps(str, dt, ts, dtime) values('bbb', '1990-12-31', '2000-09-01 12:12:12', '2010-07-01 12:12:12.123');
insert into round_ps(str, dt, ts, dtime) values('bbb', '1993-12-1', '2003-09-16 12:12:12', '2043-07-01 12:12:12.123');
insert into round_ps(str, dt, ts, dtime) values('bbb', '1994-12-1', '2004-09-01 12:12:12', '2044-07-31 12:12:12.123');
insert into round_ps(str, dt, ts, dtime) values('ccc', '1990-12-1', '2000-09-01 12:12:12', '2047-07-01 12:12:12.123');
insert into round_ps(str, dt, ts, dtime) values('ccc', '1997-12-31', '2007-09-15 12:12:12', '2048-07-01 12:12:12.123');
insert into round_ps(str, dt, ts, dtime) values('ccc', '1998-12-1', '2008-09-01 12:12:12', '2010-07-16 12:12:12.123');
insert into round_ps(str, dt, ts, dtime) values('ddd', '1990-12-1', '2000-09-01 12:12:12', '2010-07-01 12:12:12.123');
insert into round_ps(str, dt, ts, dtime) values('ddd', '1999-12-29', '2009-09-01 12:12:12', '2049-07-01 12:12:12.123');
insert into round_ps(str, dt, ts, dtime) values('ddd', '1999-12-1', '2009-09-01 12:12:12', '2049-07-14 12:12:12.123');


prepare st from 'select id, str, dt, round(dt) from round_ps where round(dt) < ? and round(ts) > ? order by 1';
execute st using '1994-12-12', '2002-1-1';

prepare st from 'select id, str, dtime, round(dtime) from round_ps where round(dtime, ?) between round(?) and round(?) order by 1';
execute st using 'dd', date'2012-1-1', date'2018-12-12';

prepare st from 'select id, str, dt, ts, round(ts) from round_ps where dt in (round(?), round(?)) order by 1';
execute st using date'1990-12-31', date'12/15/1994';

prepare st from 'select 1 from (select id, str, dt, round(ts), round(dtime) from round_ps where dtime >= round(sysdatetime) or ts between round(?) and (round(?) + 1)) order by 1';
execute st using date'2008-10-25', timestamp'2013-12-12 11:11:11';

prepare st from 'select 100 from (select id, str, dt, round(ts), round(dtime) from round_ps where dt < round(sysdate) and ts between round(?) and (round(?) + 1)) order by 1';
execute st using date'2005-10-25', timestamp'2013-12-12 11:11:11';

prepare st from 'insert into round_ps(str, dt, ts, dtime) select str, round(?), round(ts), round(dtime) from round_ps where dt between round(?) and (round(?) -1) order by 1';
execute st using datetime'2013-12-12 11:11:11.999', date'1993-12-1', date'1998-1-1';

prepare st from 'insert into round_ps(str, dt) values(?, round(sysdate, ?))';
execute st using 'inserted', 'dd';

prepare st from 'select if(dt=sysdate, ?, ?) from round_ps where str=?;';
execute st using 'ok', 'nok', 'inserted';
deallocate prepare st;



drop table round_ps;

commit;
set system parameters 'dont_reuse_heap_file=no';
--+ holdcas off;
