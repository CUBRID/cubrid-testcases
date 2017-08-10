--pass time type/format argument


--TEST: pass only one argument
select trunc(time'15:23:56');
select trunc('15:23:56');


--TEST: pass time type argument, select directly
select trunc(time'15:23:56', 'yyyy');
select trunc(time'15:23:56', 'yy');
select trunc(time'12/20/1999 15:23:56', 'q');
select trunc(time'15:23:56', 'mm');
select trunc(time'15:23:56', 'month');
select trunc(time'15:23:56', 'mon');
select trunc(time'15:23:56', 'dd');
select trunc(time'15:23:56', 'day');
select trunc(time'15:23:56', 'dy');
select trunc(time'15:23:56', 'd');
select trunc(time'15:23:56', 'hh');
select trunc(time'15:23:56', 'hh12');
select trunc(time'15:23:56', 'mi');
select trunc(time'15:23:56', 'ss');
select trunc(time'15:23:56', 'ff');


--TEST: pass time format string argument, select directly
select trunc('15:23:56', 'yyyy');
select trunc('15:23:56', 'yy');
select trunc('12/20/1999 15:23:56', 'q');
select trunc('15:23:56', 'mm');
select trunc('15:23:56', 'month');
select trunc('15:23:56', 'mon');
select trunc('15:23:56', 'dd');
select trunc('15:23:56', 'day');
select trunc('15:23:56', 'dy');
select trunc('15:23:56', 'd');
select trunc('15:23:56', 'hh');
select trunc('15:23:56', 'hh12');
select trunc('15:23:56', 'mi');
select trunc('15:23:56', 'ss');
select trunc('15:23:56', 'ff');


--TEST: select from a table
create table trunc_time(
	col1 time,
	col2 time not null
);

insert into trunc_time values(time'10:24:06 AM', '10:24:06');
insert into trunc_time values(time'10:24:06', '10:24:06 pm');


--TEST: pass time format string argument, select directly
select trunc(col1, 'yyyy'), trunc(col2, 'yyyy') from trunc_time;
select trunc(col1, 'yy'), trunc(col2, 'yy') from trunc_time;
select trunc(col1, 'q'), trunc(col2, 'q') from trunc_time;
select trunc(col1, 'mm'), trunc(col2, 'mm') from trunc_time;
select trunc(col1, 'month'), trunc(col2, 'month') from trunc_time;
select trunc(col1, 'mon'), trunc(col2, 'mon') from trunc_time;
select trunc(col1, 'dd'), trunc(col2, 'dd') from trunc_time;
select trunc(col1, 'day'), trunc(col2, 'day') from trunc_time;
select trunc(col1, 'dy'), trunc(col2, 'dy') from trunc_time;
select trunc(col1, 'd'), trunc(col2, 'd') from trunc_time;
select trunc(col1, 'hh'), trunc(col2, 'hh') from trunc_time;
select trunc(col1, 'hh12'), trunc(col2, 'hh24') from trunc_time;
select trunc(col1, 'mi'), trunc(col2, 'mi') from trunc_time;
select trunc(col1, 'ss'), trunc(col2, 'ss') from trunc_time;
select trunc(col1, 'ff'), trunc(col2, 'ff') from trunc_time;

drop table trunc_time;
