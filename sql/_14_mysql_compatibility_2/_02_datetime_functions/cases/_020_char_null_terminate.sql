create table char_null_terminate (date_char_col char(32),
					format_char_col char(32),
					date_nchar_col nchar(32),
					format_nchar_col nchar(32),
					date_varchar_col varchar(32),
					format_varchar_col varchar(32),
					date_varnchar_col nchar varying(32),
					format_varnchar_col nchar varying(32));

insert into char_null_terminate values ('2010-01-01', '%M %Y %W', N'2010-01-01', N'%M %Y %W', '2010-01-01', '%M %Y %W', N'2010-01-01', N'%M %Y %W');

select date(date_char_col) from char_null_terminate;

select date(date_nchar_col) from char_null_terminate;

-- unix_timestamp result depends on the timezone, so we will use IF

select if(unix_timestamp(date_char_col) = unix_timestamp(date_char_col),'ok','nok') from char_null_terminate;

select if(unix_timestamp(date_nchar_col) = unix_timestamp(date_nchar_col),'ok','nok') from char_null_terminate;

select timestamp(date_char_col) from char_null_terminate;

select timestamp(date_nchar_col) from char_null_terminate;

select date_format(date_char_col, format_char_col) from char_null_terminate;

select date_format(date_nchar_col, format_char_col) from char_null_terminate;

select date_format(date_nchar_col, format_nchar_col) from char_null_terminate;

select date_format(date_char_col, format_nchar_col) from char_null_terminate;

select date_format(date_varchar_col, format_char_col) from char_null_terminate;

select date_format(date_varchar_col, format_nchar_col) from char_null_terminate;

select date_format(date_varnchar_col, format_char_col) from char_null_terminate;

select date_format(date_varnchar_col, format_nchar_col) from char_null_terminate;

select date_format(date_char_col, format_varchar_col) from char_null_terminate;

select date_format(date_char_col, format_varnchar_col) from char_null_terminate;

select date_format(date_nchar_col, format_varchar_col) from char_null_terminate;

select date_format(date_nchar_col, format_varnchar_col) from char_null_terminate;

drop table char_null_terminate;

create table char_null_terminate (time_char_col char(32),
					format_char_col char(32),
					time_nchar_col nchar(32),
					format_nchar_col nchar(32),
					time_varchar_col varchar(32),
					format_varchar_col varchar(32),
					time_varnchar_col nchar varying(32),
					format_varnchar_col nchar varying(32));
					
insert into char_null_terminate values ('12:00:00', '%h %m %s', N'12:00:00', N'%h %m %s', '12:00:00', '%h %m %s', N'12:00:00', N'%h %m %s');

select time_format(time_char_col, format_char_col) from char_null_terminate;

select time_format(time_char_col, format_nchar_col) from char_null_terminate;

select time_format(time_varchar_col, format_char_col) from char_null_terminate;

select time_format(time_varchar_col, format_nchar_col) from char_null_terminate;

select time_format(time_char_col, format_varchar_col) from char_null_terminate;

select time_format(time_char_col, format_varnchar_col) from char_null_terminate;

drop table char_null_terminate;
