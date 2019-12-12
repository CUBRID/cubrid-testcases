--pass time type/format argument


--TEST: pass only one argument
select round(time'15:23:56');
select round('15:23:56');


--TEST: pass time type argument, select directly
select round(time'15:23:56', 'yyyy');
select round(time'15:23:56', 'yy');
select round(time'12/20/1999 15:23:56', 'q');
select round(time'15:23:56', 'mm');
select round(time'15:23:56', 'month');
select round(time'15:23:56', 'mon');
select round(time'15:23:56', 'dd');
select round(time'15:23:56', 'day');
select round(time'15:23:56', 'dy');
select round(time'15:23:56', 'd');
select round(time'15:23:56', 'hh');
select round(time'15:23:56', 'hh12');
select round(time'15:23:56', 'mi');
select round(time'15:23:56', 'ss');
select round(time'15:23:56', 'ff');


--TEST: pass time format string argument, select directly
select round('15:23:56', 'yyyy');
select round('15:23:56', 'yy');
select round('12/20/1999 15:23:56', 'q');
select round('15:23:56', 'mm');
select round('15:23:56', 'month');
select round('15:23:56', 'mon');
select round('15:23:56', 'dd');
select round('15:23:56', 'day');
select round('15:23:56', 'dy');
select round('15:23:56', 'd');
select round('15:23:56', 'hh');
select round('15:23:56', 'hh12');
select round('15:23:56', 'mi');
select round('15:23:56', 'ss');
select round('15:23:56', 'ff');


--TEST: select from a table
create table round_time(
	col1 time,
	col2 time not null
);

insert into round_time values(time'10:24:06 AM', '10:24:06');
insert into round_time values(time'10:24:06', '10:24:06 pm');


--TEST: pass time format string argument, select directly
select round(col1, 'yyyy'), round(col2, 'yyyy') from round_time;
select round(col1, 'yy'), round(col2, 'yy') from round_time;
select round(col1, 'q'), round(col2, 'q') from round_time;
select round(col1, 'mm'), round(col2, 'mm') from round_time;
select round(col1, 'month'), round(col2, 'month') from round_time;
select round(col1, 'mon'), round(col2, 'mon') from round_time;
select round(col1, 'dd'), round(col2, 'dd') from round_time;
select round(col1, 'day'), round(col2, 'day') from round_time;
select round(col1, 'dy'), round(col2, 'dy') from round_time;
select round(col1, 'd'), round(col2, 'd') from round_time;
select round(col1, 'hh'), round(col2, 'hh') from round_time;
select round(col1, 'hh12'), round(col2, 'hh24') from round_time;
select round(col1, 'mi'), round(col2, 'mi') from round_time;
select round(col1, 'ss'), round(col2, 'ss') from round_time;
select round(col1, 'ff'), round(col2, 'ff') from round_time;

drop table round_time;
