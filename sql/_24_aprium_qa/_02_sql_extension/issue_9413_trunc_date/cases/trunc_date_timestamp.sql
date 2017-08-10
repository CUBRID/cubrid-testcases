--pass timestamp type/format argument


--TEST: pass only one argument
select trunc(timestamp'1999-12-20 15:23:56');
select trunc('12/20/1999 15:23:56');


--TEST: pass timestamp type argument, select directly
select trunc(timestamp'1999-12-20 15:23:56', 'yyyy');
select trunc(timestamp'1999-12-20 15:23:56', 'yy');
select trunc(timestamp'12/20/1999 15:23:56', 'q');
select trunc(timestamp'1999-12-20 15:23:56', 'mm');
select trunc(timestamp'1999-12-20 15:23:56', 'month');
select trunc(timestamp'1999-12-20 15:23:56', 'mon');
select trunc(timestamp'1999-12-20 15:23:56', 'dd');
select trunc(timestamp'1999-12-20 15:23:56', 'day');
select trunc(timestamp'1999-12-20 15:23:56', 'dy');
select trunc(timestamp'1999-12-20 15:23:56', 'd');
select trunc(timestamp'1999-12-20 15:23:56', 'hh');
select trunc(timestamp'1999-12-20 15:23:56', 'hh12');
select trunc(timestamp'1999-12-20 15:23:56', 'mi');
select trunc(timestamp'1999-12-20 15:23:56', 'ss');
select trunc(timestamp'1999-12-20 15:23:56', 'ff');


--TEST: pass timestamp format string argument, select directly
select trunc('1999-12-20 15:23:56', 'yyyy');
select trunc('1999-12-20 15:23:56', 'yy');
select trunc('12/20/1999 15:23:56', 'q');
select trunc('1999-12-20 15:23:56', 'mm');
select trunc('1999-12-20 15:23:56', 'month');
select trunc('1999-12-20 15:23:56', 'mon');
select trunc('1999-12-20 15:23:56', 'dd');
select trunc('1999-12-20 15:23:56', 'day');
select trunc('1999-12-20 15:23:56', 'dy');
select trunc('1999-12-20 15:23:56', 'd');
select trunc('1999-12-20 15:23:56', 'hh');
select trunc('1999-12-20 15:23:56', 'hh12');
select trunc('1999-12-20 15:23:56', 'mi');
select trunc('1999-12-20 15:23:56', 'ss');
select trunc('1999-12-20 15:23:56', 'ff');


--TEST: select from a table
create table trunc_timestamp(
	col1 timestamp,
	col2 timestamp not null
);

insert into trunc_timestamp values(timestamp'05/13/2020 10:24:06', '05/13/2020 10:24:06');
insert into trunc_timestamp values(timestamp'11/05/1987 10:24:06', '1987-11-05 10:24:06');


--TEST: pass timestamp format string argument, select directly
select trunc(col1, 'yyyy'), trunc(col2, 'yyyy') from trunc_timestamp order by 1;
select trunc(col1, 'yy'), trunc(col2, 'yy') from trunc_timestamp order by 1;
select trunc(col1, 'q'), trunc(col2, 'q') from trunc_timestamp order by 1;
select trunc(col1, 'mm'), trunc(col2, 'mm') from trunc_timestamp order by 1;
select trunc(col1, 'month'), trunc(col2, 'month') from trunc_timestamp order by 1;
select trunc(col1, 'mon'), trunc(col2, 'mon') from trunc_timestamp order by 1;
select trunc(col1, 'dd'), trunc(col2, 'dd') from trunc_timestamp order by 1;
select trunc(col1, 'day'), trunc(col2, 'day') from trunc_timestamp order by 1;
select trunc(col1, 'dy'), trunc(col2, 'dy') from trunc_timestamp order by 1;
select trunc(col1, 'd'), trunc(col2, 'd') from trunc_timestamp order by 1;
select trunc(col1, 'hh'), trunc(col2, 'hh') from trunc_timestamp order by 1;
select trunc(col1, 'hh12'), trunc(col2, 'hh24') from trunc_timestamp order by 1;
select trunc(col1, 'mi'), trunc(col2, 'mi') from trunc_timestamp order by 1;
select trunc(col1, 'ss'), trunc(col2, 'ss') from trunc_timestamp order by 1;
select trunc(col1, 'ff'), trunc(col2, 'ff') from trunc_timestamp order by 1;

drop table trunc_timestamp;
