autocommit off;
set system parameters 'return_null_on_function_errors=no';
set system parameters 'compat_mode=cubrid';

select DATE '09/01/2009' - cast(1 as SHORT) from db_root;
select datetimetz '09/01/2009 03:30:30 pm' - cast(1 as SHORT) from db_root;
select timestamptz '09/01/2009 03:30:30 pm' - cast(1 as SHORT) from db_root;

select DATE '09/01/2009' - cast(1 as INTEGER) from db_root;
select datetimetz '09/01/2009 03:30:30 pm' - cast(1 as INTEGER) from db_root;
select timestamptz '09/01/2009 03:30:30 pm' - cast(1 as INTEGER) from db_root;

select DATE '09/01/2009' - cast(1 as BIGINT) from db_root;
select datetimetz '09/01/2009 03:30:30 pm' - cast(1 as BIGINT) from db_root;
select timestamptz '09/01/2009 03:30:30 pm' - cast(1 as BIGINT) from db_root;


select DATE '09/01/2009' - cast(-1 as SHORT) from db_root;
select datetimetz '09/01/2009 03:30:30 pm' - cast(-1 as SHORT) from db_root;
select timestamptz '09/01/2009 03:30:30 pm' - cast(-1 as SHORT) from db_root;

select DATE '09/01/2009' - cast(-1 as INTEGER) from db_root;
select datetimetz '09/01/2009 03:30:30 pm' - cast(-1 as INTEGER) from db_root;
select timestamptz '09/01/2009 03:30:30 pm' - cast(-1 as INTEGER) from db_root;

select DATE '09/01/2009' - cast(-1 as BIGINT) from db_root;
select datetimetz '09/01/2009 03:30:30 pm' - cast(-1 as BIGINT) from db_root;
select timestamptz '09/01/2009 03:30:30 pm' - cast(-1 as BIGINT) from db_root;

--
-- date/ - date/
--
select DATE '09/01/2009' - DATE '08/31/2009' from db_root;
select datetimetz '09/01/2009 03:30:30 pm' - datetimetz '08/31/2009 03:30:30 pm' from db_root;
select timestamptz '09/01/2009 03:30:30 pm' - timestamptz '08/31/2009 03:30:30 pm' from db_root;
-- not defined
select datetimetz '09/01/2009 03:30:30 pm' - timestamptz '08/31/2009 03:30:30 pm' from db_root;
select timestamptz '09/01/2009 03:30:30 pm' - datetimetz '08/31/2009 03:30:30 pm' from db_root;
-- min - max
select DATE '01/01/0001' - DATE '12/31/9999' from db_root;
select datetimetz '01/01/0001 00:00:00 am' - datetimetz '12/31/9999 11:59:59 pm' from db_root;
--select timestamptz '01/01/1970 09:00:00 am' - timestamptz '01/19/2038 12:14:07 pm' from db_root;
-- max - min
select DATE '12/31/9999' - DATE '01/01/0001' from db_root;
select datetimetz '12/31/9999 11:59:59 pm' - datetimetz '01/01/0001 00:00:00 am' from db_root;
--select timestamptz '01/19/2038 12:14:07 pm' - timestamptz '01/01/1970 09:00:00 am' from db_root;
-- min - 1
select DATE '01/01/0001' - DATE '01/02/0001' from db_root;
select datetimetz '01/01/0001 00:00:00 am' - datetimetz '01/01/0001 00:00:01 am' from db_root;
select timestamptz '01/01/1970 09:00:00 am' - timestamptz '01/01/1970 09:00:01 am' from db_root;


--
-- underflow case (except)
--
select DATE '01/01/0001' - cast(1 as SHORT) from db_root;
select datetimetz '01/01/0001 00:00:00 am' - cast(1 as SHORT) from db_root;
--select timestamptz '01/01/1970 09:00:00 am' - cast(1 as SHORT) from db_root;

select DATE '01/01/0001' - cast(1 as INTEGER) from db_root;
select datetimetz '01/01/0001 00:00:00 am' - cast(1 as INTEGER) from db_root;
--select timestamptz '01/01/1970 09:00:00 am' - cast(1 as INTEGER) from db_root;

select DATE '01/01/0001' - cast(1 as BIGINT) from db_root;
select datetimetz '01/01/0001 00:00:00 am' - cast(1 as BIGINT) from db_root;
--select timestamptz '01/01/1970 09:00:00 am' - cast(1 as BIGINT) from db_root;

-- number - date/
-- normal case
select cast(100 as SHORT) - DATE '01/01/0001' from db_root;
select cast(100 as SHORT) - datetimetz '01/01/0001 00:00:00 am' from db_root;
--select cast(100 as SHORT) - timestamptz '01/01/1970 09:00:00 am' from db_root;

select cast(100 as INTEGER) - DATE '01/01/0001' from db_root;
select cast(100 as INTEGER) - datetimetz '01/01/0001 00:00:00 am' from db_root;
--select cast(100 as INTEGER) - timestamptz '01/01/1970 09:00:00 am' from db_root;

select cast(100 as BIGINT) - DATE '01/01/0001' from db_root;
select cast(100 as BIGINT) - datetimetz '01/01/0001 00:00:00 am' from db_root;
--select cast(100 as BIGINT) - timestamptz '01/01/1970 09:00:00 am' from db_root;

-- underflow case (except ) 1 - MAX
select cast(1 as SHORT) - DATE '12/31/9999' from db_root;
select cast(1 as SHORT) - datetimetz '12/31/9999 11:59:59 pm' from db_root;
--select cast(1 as SHORT) - timestamptz '01/19/2038 12:14:07 pm' from db_root;

select cast(1 as INTEGER) - DATE '12/31/9999' from db_root;
select cast(1 as INTEGER) - datetimetz '12/31/9999 11:59:59 pm' from db_root;
--select cast(1 as INTEGER) - timestamptz '01/19/2038 12:14:07 pm' from db_root;

select cast(1 as BIGINT) - DATE '12/31/9999' from db_root;
select cast(1 as BIGINT) - datetimetz '12/31/9999 11:59:59 pm' from db_root;
--select cast(1 as BIGINT) - timestamptz '01/19/2038 12:14:07 pm' from db_root;

-- underflow case (except ) MIN - MAX
select cast(-32768 as SHORT) - DATE '12/31/9999' from db_root;
select cast(-32768 as SHORT) - datetimetz '12/31/9999 11:59:59 pm' from db_root;
--select cast(-32768 as SHORT) - timestamptz '01/19/2038 12:14:07 pm' from db_root;

select cast(-2147483648 as INTEGER) - DATE '12/31/9999' from db_root;
select cast(-2147483648 as INTEGER) - datetimetz '12/31/9999 11:59:59 pm' from db_root;
--select cast(-2147483648 as INTEGER) - timestamptz '01/19/2038 12:14:07 pm' from db_root;

select cast(-9223372036854775808 as BIGINT) - DATE '12/31/9999' from db_root;
select cast(-9223372036854775808 as BIGINT) - datetimetz '12/31/9999 11:59:59 pm' from db_root;
--select cast(-9223372036854775808 as BIGINT) - timestamptz '01/19/2038 12:14:07 pm' from db_root;

commit;
autocommit on;
