--time
select time'12:00:00' - cast (1 as smallint) from db_root;
select time'12:00:00' - cast (1 as integer) from db_root;
select time'12:00:00' - cast (1 as bigint) from db_root;

select time'13:00:00' - cast (-1 as smallint) from db_root;
select time'13:00:00' - cast (-1 as integer) from db_root;
select time'13:00:00' - cast (-1 as bigint) from db_root;

select time'23:59:59' - cast (-2 as smallint) from db_root;
select time'23:59:59' - cast (-2 as integer) from db_root;
select time'23:59:59' - cast (-2 as bigint) from db_root;

select time'00:00:00' - cast(1 as smallint) from db_root;
select time'00:00:00' - cast(1 as integer) from db_root;
select time'00:00:00' - cast(1 as bigint) from db_root;

--date
select date'2010-01-01' - cast(1 as smallint) from db_root;
select date'2010-01-01' - cast(1 as integer) from db_root;
select date'2010-01-01' - cast(1 as integer) from db_root;

select date'0001-01-01' - cast(1 as smallint) from db_root;
select date'0001-01-01' - cast(1 as integer) from db_root;
select date'0001-01-01' - cast(1 as integer) from db_root;

select date'9999-12-31' - cast(-1 as smallint) from db_root;
select date'9999-12-31' - cast(-1 as integer) from db_root;
select date'9999-12-31' - cast(-1 as integer) from db_root;

--datetime
select datetime'2010-01-01 12:00:00' - cast(1 as smallint) from db_root;
select datetime'2010-01-01 12:00:00' - cast(1 as integer) from db_root;
select datetime'2010-01-01 12:00:00' - cast(1 as integer) from db_root;

select datetime'0001-01-01 12:00:00' - cast(1 as smallint) from db_root;
select datetime'0001-01-01 12:00:00' - cast(1 as integer) from db_root;
select datetime'0001-01-01 12:00:00' - cast(1 as integer) from db_root;

select datetime'9999-12-31 12:00:00' - cast(-1 as smallint) from db_root;
select datetime'9999-12-31 12:00:00' - cast(-1 as integer) from db_root;
select datetime'9999-12-31 12:00:00' - cast(-1 as integer) from db_root;

--timestamp
select timestamp'2010-01-01 12:00:00' - cast(-1 as smallint) from db_root;
select timestamp'2010-01-01 12:00:00' - cast(-1 as integer) from db_root;
select timestamp'2010-01-01 12:00:00' - cast(-1 as integer) from db_root;

select cast(32767 as SHORT) - TIMESTAMP '01/19/2038 12:14:07 pm' from db_root;
select cast(2147483647 as INTEGER) - TIMESTAMP '01/19/2038 12:14:07 pm' from db_root;
select cast(9223372036854775807 as BIGINT) - TIMESTAMP '01/19/2038 12:14:07 pm' from db_root;

select cast(-32767 as SHORT) - TIMESTAMP '01/19/2038 12:14:07 pm' from db_root;
select cast(-2147483647 as INTEGER) - TIMESTAMP '01/19/2038 12:14:07 pm' from db_root;
select cast(-9223372036854775807 as BIGINT) - TIMESTAMP '01/19/2038 12:14:07 pm' from db_root;

select cast(1 as SHORT) - TIMESTAMP '01/18/2038 12:00:00' from db_root;
select cast(1 as INTEGER) - TIMESTAMP '01/19/2038 12:00:00' from db_root;
select cast(1 as BIGINT) - TIMESTAMP '01/19/2038 12:00:00' from db_root;

select cast(-1 as SHORT) - TIMESTAMP '01/18/2038 12:00:00' from db_root;
select cast(-1 as INTEGER) - TIMESTAMP '01/19/2038 12:00:00' from db_root;
select cast(-1 as BIGINT) - TIMESTAMP '01/19/2038 12:00:00' from db_root;

select TIMESTAMP '01/19/2038 12:14:07 pm' - cast(32767 as SHORT) from db_root;
select TIMESTAMP '01/19/2038 12:14:07 pm' - cast(2147483647 as INTEGER) from db_root;
select TIMESTAMP '01/19/2038 12:14:07 pm' - cast(9223372036854775807 as BIGINT) from db_root;

select TIMESTAMP '01/19/2038 12:14:07 pm' - cast(-32767 as SHORT) from db_root;
select TIMESTAMP '01/19/2038 12:14:07 pm' - cast(-2147483647 as INTEGER) from db_root;
select TIMESTAMP '01/19/2038 12:14:07 pm' - cast(-9223372036854775807 as BIGINT) from db_root;
