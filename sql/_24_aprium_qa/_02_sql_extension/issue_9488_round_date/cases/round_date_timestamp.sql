--pass timestamp type/format argument


--TEST: pass only one argument
select round(timestamp'1999-12-20 15:23:56');
select round('12/20/1999 15:23:56');


--TEST: pass timestamp type argument, select directly
select round(timestamp'1999-12-20 15:23:56', 'yyyy');
select round(timestamp'1999-12-20 15:23:56', 'yy');
select round(timestamp'12/20/1999 15:23:56', 'q');
select round(timestamp'1999-12-20 15:23:56', 'mm');
select round(timestamp'1999-12-20 15:23:56', 'month');
select round(timestamp'1999-12-20 15:23:56', 'mon');
select round(timestamp'1999-12-20 15:23:56', 'dd');
select round(timestamp'1999-12-20 15:23:56', 'day');
select round(timestamp'1999-12-20 15:23:56', 'dy');
select round(timestamp'1999-12-20 15:23:56', 'd');
select round(timestamp'1999-12-20 15:23:56', 'hh');
select round(timestamp'1999-12-20 15:23:56', 'hh12');
--NOK
select round(timestamp'1999-12-20 15:23:56', 'mi');
--NOK
select round(timestamp'1999-12-20 15:23:56', 'ss');
--NOK
select round(timestamp'1999-12-20 15:23:56', 'ff');


--TEST: pass timestamp format string argument, select directly
select round('1999-12-20 15:23:56', 'yyyy');
select round('1999-12-20 15:23:56', 'yy');
select round('12/20/1999 15:23:56', 'q');
select round('1999-12-20 15:23:56', 'mm');
select round('1999-12-20 15:23:56', 'month');
select round('1999-12-20 15:23:56', 'mon');
select round('1999-12-20 15:23:56', 'dd');
select round('1999-12-20 15:23:56', 'day');
select round('1999-12-20 15:23:56', 'dy');
select round('1999-12-20 15:23:56', 'd');
select round('1999-12-20 15:23:56', 'hh');
select round('1999-12-20 15:23:56', 'hh12');
select round('1999-12-20 15:23:56', 'mi');
select round('1999-12-20 15:23:56', 'ss');
select round('1999-12-20 15:23:56', 'ff');


--TEST: select from a table
create table round_timestamp(
	col1 timestamp,
	col2 timestamp not null
);

insert into round_timestamp values(timestamp'05/13/2020 10:24:06', '05/13/2020 10:24:06');
insert into round_timestamp values(timestamp'11/05/1987 10:24:06', '1987-11-05 10:24:06');


--TEST: pass timestamp format string argument, select directly
select round(col1, 'yyyy'), round(col2, 'yyyy') from round_timestamp;
select round(col1, 'yy'), round(col2, 'yy') from round_timestamp;
select round(col1, 'q'), round(col2, 'q') from round_timestamp;
select round(col1, 'mm'), round(col2, 'mm') from round_timestamp;
select round(col1, 'month'), round(col2, 'month') from round_timestamp;
select round(col1, 'mon'), round(col2, 'mon') from round_timestamp;
select round(col1, 'dd'), round(col2, 'dd') from round_timestamp;
select round(col1, 'day'), round(col2, 'day') from round_timestamp;
select round(col1, 'dy'), round(col2, 'dy') from round_timestamp;
select round(col1, 'd'), round(col2, 'd') from round_timestamp;
select round(col1, 'hh'), round(col2, 'hh') from round_timestamp;
select round(col1, 'hh12'), round(col2, 'hh24') from round_timestamp;
select round(col1, 'mi'), round(col2, 'mi') from round_timestamp;
select round(col1, 'ss'), round(col2, 'ss') from round_timestamp;
select round(col1, 'ff'), round(col2, 'ff') from round_timestamp;

drop table round_timestamp;
