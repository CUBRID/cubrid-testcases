--+ holdcas on;
set system parameters 'compat_mode=cubrid';
select TIME '03:30:30 pm' - cast(1 as SHORT) from db_root;
select DATE '09/01/2009' - cast(1 as SHORT) from db_root;
select DATETIME '09/01/2009 03:30:30 pm' - cast(1 as SHORT) from db_root;
select TIMESTAMP '09/01/2009 03:30:30 pm' - cast(1 as SHORT) from db_root;

select TIME '03:30:30 pm' - cast(1 as INTEGER) from db_root;
select DATE '09/01/2009' - cast(1 as INTEGER) from db_root;
select DATETIME '09/01/2009 03:30:30 pm' - cast(1 as INTEGER) from db_root;
select TIMESTAMP '09/01/2009 03:30:30 pm' - cast(1 as INTEGER) from db_root;

select TIME '03:30:30 pm' - cast(1 as BIGINT) from db_root;
select DATE '09/01/2009' - cast(1 as BIGINT) from db_root;
select DATETIME '09/01/2009 03:30:30 pm' - cast(1 as BIGINT) from db_root;
select TIMESTAMP '09/01/2009 03:30:30 pm' - cast(1 as BIGINT) from db_root;


select TIME '03:30:30 pm' - cast(-1 as SHORT) from db_root;
select DATE '09/01/2009' - cast(-1 as SHORT) from db_root;
select DATETIME '09/01/2009 03:30:30 pm' - cast(-1 as SHORT) from db_root;
select TIMESTAMP '09/01/2009 03:30:30 pm' - cast(-1 as SHORT) from db_root;

select TIME '03:30:30 pm' - cast(-1 as INTEGER) from db_root;
select DATE '09/01/2009' - cast(-1 as INTEGER) from db_root;
select DATETIME '09/01/2009 03:30:30 pm' - cast(-1 as INTEGER) from db_root;
select TIMESTAMP '09/01/2009 03:30:30 pm' - cast(-1 as INTEGER) from db_root;

select TIME '03:30:30 pm' - cast(-1 as BIGINT) from db_root;
select DATE '09/01/2009' - cast(-1 as BIGINT) from db_root;
select DATETIME '09/01/2009 03:30:30 pm' - cast(-1 as BIGINT) from db_root;
select TIMESTAMP '09/01/2009 03:30:30 pm' - cast(-1 as BIGINT) from db_root;

--
-- date/time - date/time
--
select TIME '03:30:30 pm' - TIME '03:00:00 pm' from db_root;
select DATE '09/01/2009' - DATE '08/31/2009' from db_root;
select DATETIME '09/01/2009 03:30:30 pm' - DATETIME '08/31/2009 03:30:30 pm' from db_root;
select TIMESTAMP '09/01/2009 03:30:30 pm' - TIMESTAMP '08/31/2009 03:30:30 pm' from db_root;
-- not defined
select DATETIME '09/01/2009 03:30:30 pm' - TIMESTAMP '08/31/2009 03:30:30 pm' from db_root;
select TIMESTAMP '09/01/2009 03:30:30 pm' - DATETIME '08/31/2009 03:30:30 pm' from db_root;
-- min - max
select TIME '00:00:00 am' - TIME '11:59:59 pm' from db_root;
select DATE '01/01/0001' - DATE '12/31/9999' from db_root;
select DATETIME '01/01/0001 00:00:00 am' - DATETIME '12/31/9999 11:59:59 pm' from db_root;
--select TIMESTAMP '01/01/1970 09:00:00 am' - TIMESTAMP '01/19/2038 12:14:07 pm' from db_root;
-- max - min
select TIME '11:59:59 pm' - TIME '00:00:00 am' from db_root;
select DATE '12/31/9999' - DATE '01/01/0001' from db_root;
select DATETIME '12/31/9999 11:59:59 pm' - DATETIME '01/01/0001 00:00:00 am' from db_root;
--select TIMESTAMP '01/19/2038 12:14:07 pm' - TIMESTAMP '01/01/1970 09:00:00 am' from db_root;
-- min - 1
select TIME '00:00:00 am' - TIME '00:00:01 am' from db_root;
select DATE '01/01/0001' - DATE '01/02/0001' from db_root;
select DATETIME '01/01/0001 00:00:00 am' - DATETIME '01/01/0001 00:00:01 am' from db_root;
select TIMESTAMP '01/01/1970 09:00:00 am' - TIMESTAMP '01/01/1970 09:00:01 am' from db_root;


--
-- underflow case (except TIME)
--
select TIME '00:00:00 am' - cast(1 as SHORT) from db_root;
select DATE '01/01/0001' - cast(1 as SHORT) from db_root;
select DATETIME '01/01/0001 00:00:00 am' - cast(1 as SHORT) from db_root;
--select TIMESTAMP '01/01/1970 09:00:00 am' - cast(1 as SHORT) from db_root;

select TIME '00:00:00 am' - cast(1 as INTEGER) from db_root;
select DATE '01/01/0001' - cast(1 as INTEGER) from db_root;
select DATETIME '01/01/0001 00:00:00 am' - cast(1 as INTEGER) from db_root;
--select TIMESTAMP '01/01/1970 09:00:00 am' - cast(1 as INTEGER) from db_root;

select TIME '00:00:00 am' - cast(1 as BIGINT) from db_root;
select DATE '01/01/0001' - cast(1 as BIGINT) from db_root;
select DATETIME '01/01/0001 00:00:00 am' - cast(1 as BIGINT) from db_root;
--select TIMESTAMP '01/01/1970 09:00:00 am' - cast(1 as BIGINT) from db_root;

-- number - date/time
-- normal case
select cast(100 as SHORT) - TIME '00:00:00 am' from db_root;
select cast(100 as SHORT) - DATE '01/01/0001' from db_root;
select cast(100 as SHORT) - DATETIME '01/01/0001 00:00:00 am' from db_root;
--select cast(100 as SHORT) - TIMESTAMP '01/01/1970 09:00:00 am' from db_root;

select cast(100 as INTEGER) - TIME '00:00:00 am' from db_root;
select cast(100 as INTEGER) - DATE '01/01/0001' from db_root;
select cast(100 as INTEGER) - DATETIME '01/01/0001 00:00:00 am' from db_root;
--select cast(100 as INTEGER) - TIMESTAMP '01/01/1970 09:00:00 am' from db_root;

select cast(100 as BIGINT) - TIME '00:00:00 am' from db_root;
select cast(100 as BIGINT) - DATE '01/01/0001' from db_root;
select cast(100 as BIGINT) - DATETIME '01/01/0001 00:00:00 am' from db_root;
--select cast(100 as BIGINT) - TIMESTAMP '01/01/1970 09:00:00 am' from db_root;

-- underflow case (except TIME) 1 - MAX
select cast(1 as SHORT) - TIME '11:59:59 pm' from db_root;
select cast(1 as SHORT) - DATE '12/31/9999' from db_root;
select cast(1 as SHORT) - DATETIME '12/31/9999 11:59:59 pm' from db_root;
--select cast(1 as SHORT) - TIMESTAMP '01/19/2038 12:14:07 pm' from db_root;

select cast(1 as INTEGER) - TIME '11:59:59 pm' from db_root;
select cast(1 as INTEGER) - DATE '12/31/9999' from db_root;
select cast(1 as INTEGER) - DATETIME '12/31/9999 11:59:59 pm' from db_root;
--select cast(1 as INTEGER) - TIMESTAMP '01/19/2038 12:14:07 pm' from db_root;

select cast(1 as BIGINT) - TIME '11:59:59 pm' from db_root;
select cast(1 as BIGINT) - DATE '12/31/9999' from db_root;
select cast(1 as BIGINT) - DATETIME '12/31/9999 11:59:59 pm' from db_root;
--select cast(1 as BIGINT) - TIMESTAMP '01/19/2038 12:14:07 pm' from db_root;

-- underflow case (except TIME) MIN - MAX
select cast(-32768 as SHORT) - TIME '11:59:59 pm' from db_root;
select cast(-32768 as SHORT) - DATE '12/31/9999' from db_root;
select cast(-32768 as SHORT) - DATETIME '12/31/9999 11:59:59 pm' from db_root;
--select cast(-32768 as SHORT) - TIMESTAMP '01/19/2038 12:14:07 pm' from db_root;

select cast(-2147483648 as INTEGER) - TIME '11:59:59 pm' from db_root;
select cast(-2147483648 as INTEGER) - DATE '12/31/9999' from db_root;
select cast(-2147483648 as INTEGER) - DATETIME '12/31/9999 11:59:59 pm' from db_root;
--select cast(-2147483648 as INTEGER) - TIMESTAMP '01/19/2038 12:14:07 pm' from db_root;

select cast(-9223372036854775808 as BIGINT) - TIME '11:59:59 pm' from db_root;
select cast(-9223372036854775808 as BIGINT) - DATE '12/31/9999' from db_root;
select cast(-9223372036854775808 as BIGINT) - DATETIME '12/31/9999 11:59:59 pm' from db_root;
--select cast(-9223372036854775808 as BIGINT) - TIMESTAMP '01/19/2038 12:14:07 pm' from db_root;

commit;
--+ holdcas off;
