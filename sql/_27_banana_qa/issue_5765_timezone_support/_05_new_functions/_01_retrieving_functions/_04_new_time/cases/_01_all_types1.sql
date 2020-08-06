--test all types as the first argument

--test: normal
select new_time;
select new_time();

--test: constant
select new_time(1);
select new_time('a');

--test: all types of columns as argument
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
select new_time(c_short, '+2:00', '-11:30') from all_types;
select new_time(c_int, '+2:00', '-11:30') from all_types;
select new_time(c_bigint, '+2:00', '-11:30') from all_types;
select new_time(c_numecic, '+2:00', '-11:30') from all_types;
select new_time(c_float, '+2:00', '-11:30') from all_types;
select new_time(c_double, '+2:00', '-11:30') from all_types;
select new_time(c_date, '+2:00', '-11:30') from all_types;
select new_time(c_time, '+2:00', '-11:30') from all_types;
select new_time(c_timestamp, '+2:00', '-11:30') from all_types;
select new_time(c_datetime, '+2:00', '-11:30') from all_types;
select new_time(c_timestampltz, '+2:00', '-11:30') from all_types;
select new_time(c_timestamptz, '+2:00', '-11:30') from all_types;
select new_time(c_datetimeltz, '+2:00', '-11:30') from all_types;
select new_time(c_datetimetz, '+2:00', '-11:30') from all_types;
select new_time(c_bit, '+2:00', '-11:30') from all_types;
select new_time(c_varbit, '+2:00', '-11:30') from all_types;
select new_time(c_char, '+2:00', '-11:30') from all_types;
select new_time(c_varchar, '+2:00', '-11:30') from all_types;
select new_time(c_string, '+2:00', '-11:30') from all_types;
select new_time(c_enum, '+2:00', '-11:30') from all_types;
select new_time(c_blob, '+2:00', '-11:30') from all_types;
select new_time(c_clob, '+2:00', '-11:30') from all_types;
select new_time(c_set, '+2:00', '-11:30') from all_types;
select new_time(c_multiset, '+2:00', '-11:30') from all_types;
select new_time(c_list, '+2:00', '-11:30') from all_types;


drop table all_types;


set timezone 'Asia/Seoul';
