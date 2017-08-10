--use different data types as enum values


--TEST: error, use numeric types as enum values
create table dt(
	col enum(1, 2, 3, 5.55, 6909090)
);


drop table if exists dt;
--TEST: error, use bit type as enum values
create table dt(
	col enum(B'1010', B'1001', X'123', X'abc')
);


drop table if exists dt;
--TEST: error, user collection type as enum values
create table dt(
	col enum({'a', 'b', 'c'}, {'b', 'c', 'd'})
);


drop table if exists dt;
--TEST: error, use date/time type as enum values
create table dt(
	col enum(date'1990-12-12', time'12:12:12', timestamp'2011-12-31 23:59:59', datetime'2011-12-31 23:59:59.999')
);


drop table if exists dt;


