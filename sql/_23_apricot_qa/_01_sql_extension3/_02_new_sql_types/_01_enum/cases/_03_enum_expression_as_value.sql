--use expressions as enum values


--TEST: error, use function as enum value
create table exp (
	color enum('red', concat('light ','gray'), 'blue')
);


drop table if exists exp;
--TEST: error, use clob as enum value
create table exp (
	col enum('a', char_to_clob('abc'), 'c')
);


drop table if exists exp;
--TEST: error, use cast function as enum value
create table exp (
	col enum('a', cast('b' as char(10)), 'c')
);


drop table if exists exp;
--TEST: error, use to_char function as enum value
create table exp (
	col enum('a', to_char(12345, 'S99999'), 'c')
);


drop table if exists exp;
--TEST: error, use calculation expression as enum value
create table exp (
	col enum('a', 'b'+'c', 'd')
);


drop table if exists exp;
--TEST: error, use repeat() function as enum value
create table exp (
	col enum('a', repeat('cubrid'), 6), 'b')
);


drop table if exists exp;

