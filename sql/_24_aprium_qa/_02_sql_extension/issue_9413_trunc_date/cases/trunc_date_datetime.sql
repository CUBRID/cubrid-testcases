--pass datetime type/format argument


--TEST: pass only one argument
select trunc(datetime'1999-12-20 15:23:56.345');
select trunc('12/20/1999 15:23:56.345');


--TEST: pass datetime type argument, select directly
select trunc(datetime'1999-12-20 15:23:56.345', 'yyyy');
select trunc(datetime'1999-12-20 15:23:56.345', 'yy');
select trunc(datetime'12/20/1999 15:23:56.345', 'q');
select trunc(datetime'1999-12-20 15:23:56.345', 'mm');
select trunc(datetime'1999-12-20 15:23:56.345', 'month');
select trunc(datetime'1999-12-20 15:23:56.345', 'mon');
select trunc(datetime'1999-12-20 15:23:56.345', 'dd');
select trunc(datetime'1999-12-20 15:23:56.345', 'day');
select trunc(datetime'1999-12-20 15:23:56.345', 'dy');
select trunc(datetime'1999-12-20 15:23:56.345', 'd');
select trunc(datetime'1999-12-20 15:23:56.345', 'hh');
select trunc(datetime'1999-12-20 15:23:56.345', 'hh12');
select trunc(datetime'1999-12-20 15:23:56.345', 'mi');
select trunc(datetime'1999-12-20 15:23:56.345', 'ss');
select trunc(datetime'1999-12-20 15:23:56.345', 'ff');


--TEST: pass datetime format string argument, select directly
select trunc('1999-12-20 15:23:56.345', 'yyyy');
select trunc('1999-12-20 15:23:56.345', 'yy');
select trunc('12/20/1999 15:23:56.345', 'q');
select trunc('1999-12-20 15:23:56.345', 'mm');
select trunc('1999-12-20 15:23:56.345', 'month');
select trunc('1999-12-20 15:23:56.345', 'mon');
select trunc('1999-12-20 15:23:56.345', 'dd');
select trunc('1999-12-20 15:23:56.345', 'day');
select trunc('1999-12-20 15:23:56.345', 'dy');
select trunc('1999-12-20 15:23:56.345', 'd');
select trunc('1999-12-20 15:23:56.345', 'hh');
select trunc('1999-12-20 15:23:56.345', 'hh12');
select trunc('1999-12-20 15:23:56.345', 'mi');
select trunc('1999-12-20 15:23:56.345', 'ss');
select trunc('1999-12-20 15:23:56.345', 'ff');


--TEST: select from a table
create table trunc_datetime(
	col1 datetime,
	col2 datetime not null
);

insert into trunc_datetime values(datetime'05/13/2020 10:24:06.789 AM', '05/13/2020 10:24:06.789 am');
insert into trunc_datetime values(datetime'11/05/1987 10:24:06.789 PM', '1987-11-05 10:24:06.789 pm');


--TEST: pass datetime format string argument, select directly
select trunc(col1, 'yyyy'), trunc(col2, 'yyyy') from trunc_datetime order by 1;
select trunc(col1, 'yy'), trunc(col2, 'yy') from trunc_datetime order by 1;
select trunc(col1, 'q'), trunc(col2, 'q') from trunc_datetime order by 1;
select trunc(col1, 'mm'), trunc(col2, 'mm') from trunc_datetime order by 1;
select trunc(col1, 'month'), trunc(col2, 'month') from trunc_datetime order by 1;
select trunc(col1, 'mon'), trunc(col2, 'mon') from trunc_datetime order by 1;
select trunc(col1, 'dd'), trunc(col2, 'dd') from trunc_datetime order by 1;
select trunc(col1, 'day'), trunc(col2, 'day') from trunc_datetime order by 1;
select trunc(col1, 'dy'), trunc(col2, 'dy') from trunc_datetime order by 1;
select trunc(col1, 'd'), trunc(col2, 'd') from trunc_datetime order by 1;
select trunc(col1, 'hh'), trunc(col2, 'hh') from trunc_datetime order by 1;
select trunc(col1, 'hh12'), trunc(col2, 'hh24') from trunc_datetime order by 1;
select trunc(col1, 'mi'), trunc(col2, 'mi') from trunc_datetime order by 1;
select trunc(col1, 'ss'), trunc(col2, 'ss') from trunc_datetime order by 1;
select trunc(col1, 'ff'), trunc(col2, 'ff') from trunc_datetime order by 1;

drop table trunc_datetime;
