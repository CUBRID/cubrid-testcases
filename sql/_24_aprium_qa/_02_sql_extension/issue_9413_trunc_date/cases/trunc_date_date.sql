--pass date type/format argument


--TEST: pass only one argument
select trunc(date'1999-12-20');
select trunc('12/20/1999');


--TEST: pass date type argument, select directly
select trunc(date'1999-12-20', 'yyyy');
select trunc(date'1999-12-20', 'yy');
select trunc(date'12/20/1999', 'q');
select trunc(date'1999-12-20', 'mm');
select trunc(date'1999-12-20', 'month');
select trunc(date'1999-12-20', 'mon');
select trunc(date'1999-12-20', 'dd');
select trunc(date'1999-12-20', 'day');
select trunc(date'1999-12-20', 'dy');
select trunc(date'1999-12-20', 'd');
select trunc(date'1999-12-20', 'hh');
select trunc(date'1999-12-20', 'hh12');
select trunc(date'1999-12-20', 'mi');
select trunc(date'1999-12-20', 'ss');
select trunc(date'1999-12-20', 'ff');


--TEST: pass date format string argument, select directly
select trunc('1999-12-20', 'yyyy');
select trunc('1999-12-20', 'yy');
select trunc('12/20/1999', 'q');
select trunc('1999-12-20', 'mm');
select trunc('1999-12-20', 'month');
select trunc('1999-12-20', 'mon');
select trunc('1999-12-20', 'dd');
select trunc('1999-12-20', 'day');
select trunc('1999-12-20', 'dy');
select trunc('1999-12-20', 'd');
select trunc('1999-12-20', 'hh');
select trunc('1999-12-20', 'hh12');
select trunc('1999-12-20', 'mi');
select trunc('1999-12-20', 'ss');
select trunc('1999-12-20', 'ff');


--TEST: select from a table
create table trunc_date(
	col1 date,
	col2 date not null
);

insert into trunc_date values(date'05/13/2020', '05/13/2020');
insert into trunc_date values(date'11/05/1754', '1754-11-05');


--TEST: pass date format string argument, select directly
select trunc(col1, 'yyyy'), trunc(col2, 'yyyy') from trunc_date order by 1;
select trunc(col1, 'yy'), trunc(col2, 'yy') from trunc_date order by 1;
select trunc(col1, 'q'), trunc(col2, 'q') from trunc_date order by 1;
select trunc(col1, 'mm'), trunc(col2, 'mm') from trunc_date order by 1;
select trunc(col1, 'month'), trunc(col2, 'month') from trunc_date order by 1;
select trunc(col1, 'mon'), trunc(col2, 'mon') from trunc_date order by 1;
select trunc(col1, 'dd'), trunc(col2, 'dd') from trunc_date order by 1;
select trunc(col1, 'day'), trunc(col2, 'day') from trunc_date order by 1;
select trunc(col1, 'dy'), trunc(col2, 'dy') from trunc_date order by 1;
select trunc(col1, 'd'), trunc(col2, 'd') from trunc_date order by 1;
select trunc(col1, 'hh'), trunc(col2, 'hh') from trunc_date order by 1;
select trunc(col1, 'hh12'), trunc(col2, 'hh24') from trunc_date order by 1;
select trunc(col1, 'mi'), trunc(col2, 'mi') from trunc_date order by 1;
select trunc(col1, 'ss'), trunc(col2, 'ss') from trunc_date order by 1;
select trunc(col1, 'ff'), trunc(col2, 'ff') from trunc_date order by 1;

drop table trunc_date;
