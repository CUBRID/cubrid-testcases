set system parameters 'return_null_on_function_errors = n';
autocommit off;
set system parameters 'compat_mode=cubrid';
set timezone '+9:00';

select DATE '09/01/2009' - cast(1 as SHORT) from db_root;
select datetimeltz '09/01/2009 03:30:30 pm' - cast(1 as SHORT) from db_root;
select timestampltz '09/01/2009 03:30:30 pm' - cast(1 as SHORT) from db_root;

select DATE '09/01/2009' - cast(1 as INTEGER) from db_root;
select datetimeltz '09/01/2009 03:30:30 pm' - cast(1 as INTEGER) from db_root;
select timestampltz '09/01/2009 03:30:30 pm' - cast(1 as INTEGER) from db_root;

select DATE '09/01/2009' - cast(1 as BIGINT) from db_root;
select datetimeltz '09/01/2009 03:30:30 pm' - cast(1 as BIGINT) from db_root;
select timestampltz '09/01/2009 03:30:30 pm' - cast(1 as BIGINT) from db_root;


select DATE '09/01/2009' - cast(-1 as SHORT) from db_root;
select datetimeltz '09/01/2009 03:30:30 pm' - cast(-1 as SHORT) from db_root;
select timestampltz '09/01/2009 03:30:30 pm' - cast(-1 as SHORT) from db_root;

select DATE '09/01/2009' - cast(-1 as INTEGER) from db_root;
select datetimeltz '09/01/2009 03:30:30 pm' - cast(-1 as INTEGER) from db_root;
select timestampltz '09/01/2009 03:30:30 pm' - cast(-1 as INTEGER) from db_root;

select DATE '09/01/2009' - cast(-1 as BIGINT) from db_root;
select datetimeltz '09/01/2009 03:30:30 pm' - cast(-1 as BIGINT) from db_root;
select timestampltz '09/01/2009 03:30:30 pm' - cast(-1 as BIGINT) from db_root;

--
-- date/timeltz - date/timeltz
--
select DATE '09/01/2009' - DATE '08/31/2009' from db_root;
select datetimeltz '09/01/2009 03:30:30 pm' - datetimeltz '08/31/2009 03:30:30 pm' from db_root;
select timestampltz '09/01/2009 03:30:30 pm' - timestampltz '08/31/2009 03:30:30 pm' from db_root;
-- not defined
select datetimeltz '09/01/2009 03:30:30 pm' - timestampltz '08/31/2009 03:30:30 pm' from db_root;
select timestampltz '09/01/2009 03:30:30 pm' - datetimeltz '08/31/2009 03:30:30 pm' from db_root;
-- min - max
select DATE '01/01/0001' - DATE '12/31/9999' from db_root;
select datetimeltz '01/01/0001 00:00:00 am' - datetimeltz '12/31/9999 11:59:59 pm' from db_root;
--select timestampltz '01/01/1970 09:00:00 am' - timestampltz '01/19/2038 12:14:07 pm' from db_root;
-- max - min
select DATE '12/31/9999' - DATE '01/01/0001' from db_root;
select datetimeltz '12/31/9999 11:59:59 pm' - datetimeltz '01/01/0001 00:00:00 am' from db_root;
--select timestampltz '01/19/2038 12:14:07 pm' - timestampltz '01/01/1970 09:00:00 am' from db_root;
-- min - 1
select DATE '01/01/0001' - DATE '01/02/0001' from db_root;
select datetimeltz '01/01/0001 00:00:00 am' - datetimeltz '01/01/0001 00:00:01 am' from db_root;
select timestampltz '01/01/1970 09:00:00 am' - timestampltz '01/01/1970 09:00:01 am' from db_root;


--
-- underflow case 
--
select DATE '01/01/0001' - cast(1 as SHORT) from db_root;
select datetimeltz '01/01/0001 00:00:00 am' - cast(1 as SHORT) from db_root;
--select timestampltz '01/01/1970 09:00:00 am' - cast(1 as SHORT) from db_root;

select DATE '01/01/0001' - cast(1 as INTEGER) from db_root;
select datetimeltz '01/01/0001 00:00:00 am' - cast(1 as INTEGER) from db_root;
--select timestampltz '01/01/1970 09:00:00 am' - cast(1 as INTEGER) from db_root;

select DATE '01/01/0001' - cast(1 as BIGINT) from db_root;
select datetimeltz '01/01/0001 00:00:00 am' - cast(1 as BIGINT) from db_root;
--select timestampltz '01/01/1970 09:00:00 am' - cast(1 as BIGINT) from db_root;

-- number - date/
-- normal case
select cast(100 as SHORT) - DATE '01/01/0001' from db_root;
select cast(100 as SHORT) - datetimeltz '01/01/0001 00:00:00 am' from db_root;
--select cast(100 as SHORT) - timestampltz '01/01/1970 09:00:00 am' from db_root;

select cast(100 as INTEGER) - DATE '01/01/0001' from db_root;
select cast(100 as INTEGER) - datetimeltz '01/01/0001 00:00:00 am' from db_root;
--select cast(100 as INTEGER) - timestampltz '01/01/1970 09:00:00 am' from db_root;

select cast(100 as BIGINT) - DATE '01/01/0001' from db_root;
select cast(100 as BIGINT) - datetimeltz '01/01/0001 00:00:00 am' from db_root;
--select cast(100 as BIGINT) - timestampltz '01/01/1970 09:00:00 am' from db_root;

-- underflow case (except ) 1 - MAX
select cast(1 as SHORT) - DATE '12/31/9999' from db_root;
select cast(1 as SHORT) - datetimeltz '12/31/9999 11:59:59 pm' from db_root;
--select cast(1 as SHORT) - timestampltz '01/19/2038 12:14:07 pm' from db_root;

select cast(1 as INTEGER) - DATE '12/31/9999' from db_root;
select cast(1 as INTEGER) - datetimeltz '12/31/9999 11:59:59 pm' from db_root;
--select cast(1 as INTEGER) - timestampltz '01/19/2038 12:14:07 pm' from db_root;

select cast(1 as BIGINT) - DATE '12/31/9999' from db_root;
select cast(1 as BIGINT) - datetimeltz '12/31/9999 11:59:59 pm' from db_root;
--select cast(1 as BIGINT) - timestampltz '01/19/2038 12:14:07 pm' from db_root;

-- underflow case (except ) MIN - MAX
select cast(-32768 as SHORT) - DATE '12/31/9999' from db_root;
select cast(-32768 as SHORT) - datetimeltz '12/31/9999 11:59:59 pm' from db_root;
--select cast(-32768 as SHORT) - timestampltz '01/19/2038 12:14:07 pm' from db_root;

select cast(-2147483648 as INTEGER) - DATE '12/31/9999' from db_root;
select cast(-2147483648 as INTEGER) - datetimeltz '12/31/9999 11:59:59 pm' from db_root;
--select cast(-2147483648 as INTEGER) - timestampltz '01/19/2038 12:14:07 pm' from db_root;

select cast(-9223372036854775808 as BIGINT) - DATE '12/31/9999' from db_root;
select cast(-9223372036854775808 as BIGINT) - datetimeltz '12/31/9999 11:59:59 pm' from db_root;
--select cast(-9223372036854775808 as BIGINT) - timestampltz '01/19/2038 12:14:07 pm' from db_root;

set timezone 'default';
commit;
autocommit on;
