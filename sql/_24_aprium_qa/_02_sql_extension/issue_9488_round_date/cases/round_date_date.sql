--pass date type/format argument


--TEST: pass only one argument
select round(date'1999-12-20');
select round('12/20/1999');


--TEST: pass date type argument, select directly
select round(date'1999-12-20', 'yyyy');
select round(date'1999-12-20', 'yy');
select round(date'12/20/1999', 'q');
select round(date'1999-12-20', 'mm');
select round(date'1999-12-20', 'month');
select round(date'1999-12-20', 'mon');
select round(date'1999-12-20', 'dd');
select round(date'1999-12-20', 'day');
select round(date'1999-12-20', 'dy');
select round(date'1999-12-20', 'd');
select round(date'1999-12-20', 'hh');
select round(date'1999-12-20', 'hh12');
select round(date'1999-12-20', 'mi');
select round(date'1999-12-20', 'ss');
select round(date'1999-12-20', 'ff');


--TEST: pass date format string argument, select directly
select round('1999-12-20', 'yyyy');
select round('1999-12-20', 'yy');
select round('12/20/1999', 'q');
select round('1999-12-20', 'mm');
select round('1999-12-20', 'month');
select round('1999-12-20', 'mon');
select round('1999-12-20', 'dd');
select round('1999-12-20', 'day');
select round('1999-12-20', 'dy');
select round('1999-12-20', 'd');
select round('1999-12-20', 'hh');
select round('1999-12-20', 'hh12');
select round('1999-12-20', 'mi');
select round('1999-12-20', 'ss');
select round('1999-12-20', 'ff');


--TEST: select from a table
create table round_date(
	col1 date,
	col2 date not null
);

insert into round_date values(date'05/13/2020', '05/13/2020');
insert into round_date values(date'11/05/1754', '1754-11-05');


--TEST: pass date format string argument, select directly
select round(col1, 'yyyy'), round(col2, 'yyyy') from round_date order by 1 desc;
select round(col1, 'yy'), round(col2, 'yy') from round_date order by 1 desc;
select round(col1, 'q'), round(col2, 'q') from round_date order by 1 desc;
select round(col1, 'mm'), round(col2, 'mm') from round_date order by 1 desc;
select round(col1, 'month'), round(col2, 'month') from round_date order by 1 desc;
select round(col1, 'mon'), round(col2, 'mon') from round_date order by 1 desc;
select round(col1, 'dd'), round(col2, 'dd') from round_date order by 1 desc;
select round(col1, 'day'), round(col2, 'day') from round_date order by 1 desc;
select round(col1, 'dy'), round(col2, 'dy') from round_date order by 1 desc;
select round(col1, 'd'), round(col2, 'd') from round_date order by 1 desc;
select round(col1, 'hh'), round(col2, 'hh') from round_date order by 1 desc;
select round(col1, 'hh12'), round(col2, 'hh24') from round_date order by 1 desc;
select round(col1, 'mi'), round(col2, 'mi') from round_date order by 1 desc;
select round(col1, 'ss'), round(col2, 'ss') from round_date order by 1 desc;
select round(col1, 'ff'), round(col2, 'ff') from round_date order by 1 desc;

drop table round_date;
