--pass datetime type/format argument


--TEST: pass only one argument
select round(datetime'1999-12-20 15:23:56.345');
select round('12/20/1999 15:23:56.345');


--TEST: pass datetime type argument, select directly
select round(datetime'1999-12-20 15:23:56.345', 'yyyy');
select round(datetime'1999-12-20 15:23:56.345', 'yy');
select round(datetime'12/20/1999 15:23:56.345', 'q');
select round(datetime'1999-12-20 15:23:56.345', 'mm');
select round(datetime'1999-12-20 15:23:56.345', 'month');
select round(datetime'1999-12-20 15:23:56.345', 'mon');
select round(datetime'1999-12-20 15:23:56.345', 'dd');
select round(datetime'1999-12-20 15:23:56.345', 'day');
select round(datetime'1999-12-20 15:23:56.345', 'dy');
select round(datetime'1999-12-20 15:23:56.345', 'd');
select round(datetime'1999-12-20 15:23:56.345', 'hh');
select round(datetime'1999-12-20 15:23:56.345', 'hh12');
select round(datetime'1999-12-20 15:23:56.345', 'mi');
select round(datetime'1999-12-20 15:23:56.345', 'ss');
select round(datetime'1999-12-20 15:23:56.345', 'ff');


--TEST: pass datetime format string argument, select directly
select round('1999-12-20 15:23:56.345', 'yyyy');
select round('1999-12-20 15:23:56.345', 'yy');
select round('12/20/1999 15:23:56.345', 'q');
select round('1999-12-20 15:23:56.345', 'mm');
select round('1999-12-20 15:23:56.345', 'month');
select round('1999-12-20 15:23:56.345', 'mon');
select round('1999-12-20 15:23:56.345', 'dd');
select round('1999-12-20 15:23:56.345', 'day');
select round('1999-12-20 15:23:56.345', 'dy');
select round('1999-12-20 15:23:56.345', 'd');
select round('1999-12-20 15:23:56.345', 'hh');
select round('1999-12-20 15:23:56.345', 'hh12');
select round('1999-12-20 15:23:56.345', 'mi');
select round('1999-12-20 15:23:56.345', 'ss');
select round('1999-12-20 15:23:56.345', 'ff');


--TEST: select from a table
create table round_datetime(
	col1 datetime,
	col2 datetime not null
);

insert into round_datetime values(datetime'05/13/2020 10:24:06.789 AM', '05/13/2020 10:24:06.789 am');
insert into round_datetime values(datetime'11/05/1987 10:24:06.789 PM', '1987-11-05 10:24:06.789 pm');


--TEST: pass datetime format string argument, select directly
select round(col1, 'yyyy'), round(col2, 'yyyy') from round_datetime order by 1 desc;
select round(col1, 'yy'), round(col2, 'yy') from round_datetime order by 1 desc;
select round(col1, 'q'), round(col2, 'q') from round_datetime order by 1 desc;
select round(col1, 'mm'), round(col2, 'mm') from round_datetime order by 1 desc;
select round(col1, 'month'), round(col2, 'month') from round_datetime order by 1 desc;
select round(col1, 'mon'), round(col2, 'mon') from round_datetime order by 1 desc;
select round(col1, 'dd'), round(col2, 'dd') from round_datetime order by 1 desc;
select round(col1, 'day'), round(col2, 'day') from round_datetime order by 1 desc;
select round(col1, 'dy'), round(col2, 'dy') from round_datetime order by 1 desc;
select round(col1, 'd'), round(col2, 'd') from round_datetime order by 1 desc;
select round(col1, 'hh'), round(col2, 'hh') from round_datetime order by 1 desc;
select round(col1, 'hh12'), round(col2, 'hh24') from round_datetime order by 1 desc;
select round(col1, 'mi'), round(col2, 'mi') from round_datetime order by 1 desc;
select round(col1, 'ss'), round(col2, 'ss') from round_datetime order by 1 desc;
select round(col1, 'ff'), round(col2, 'ff') from round_datetime order by 1 desc;

drop table round_datetime;
