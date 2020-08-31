--test all types as the third argument

drop table if exists all_types;
create table all_types(
	c_short short,
	c_int int,
	c_bigint bigint,
	c_numecic numeric(6, 4),
	c_float float,
	c_double double,
	c_date date,
	c_time time,
	c_timestamp timestamp,
	c_datetime datetime,
	c_timestampltz timestamp with local time zone,
	c_timestamptz timestamp with time zone,
	c_datetimeltz datetime with local time zone,
	c_datetimetz datetime with time zone,
	c_bit bit(10),
	c_varbit bit varying,
	c_char char(10),
	c_varchar varchar(100),
	c_string string,
	c_enum enum('aaa', 'bbb', 'ccc'),
	c_blob blob,
	c_clob clob,
	c_set set(int),
	c_multiset multiset(string),
	c_list list(varchar(11))
);
	

insert into all_types values(
	10, 99, 123456789, 99.9999, 9876.5432, 1231231982892.29384928,
	date'2020-12-12', time'23:59:59', timestamp'1999-04-23 14:35:56', datetime'1999-04-23 14:35:56.789',
	timestampltz'2033-10-01 12:13:14 -12:00', timestamptz'2033-10-01 12:13:14 Europe/Riga',
	datetimeltz'1823-12-31 23:59:59 +14:00', datetimetz'2099-11-23 12:00:00 AM Australia/Eucla',
	B'1010', x'ace', 
	'hello', 'there', 'how are you', 'bbb',
	B'1010', 'clob',
	{1, 4, 7, 9}, {'a', 'c', 'g', 'e', 'a', 'g'}, {'hello', 'there', 'how are you', 'bbb'}
);


--test: [er] all types of columns as argument
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_short) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_int) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_bigint) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_numecic) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_float) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_double) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_date) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_time) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_timestamp) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_datetime) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_timestampltz) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_timestamptz) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_datetimeltz) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_datetimetz) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_bit) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_varbit) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_char) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_varchar) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_string) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_enum) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_blob) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_clob) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_set) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_multiset) from all_types;
select new_time(datetime'2000-10-10 23:22:21', 'Asia/Shanghai', c_list) from all_types;


drop table all_types;


set timezone 'Asia/Seoul';
