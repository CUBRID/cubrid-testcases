
--TIMESTAMP data type test

select timestamp'01/19/2038 12:14:07 pm' - cast(-32768 as smallint) from db_root;
select timestamp'01/19/2038 12:14:07 pm' - cast(-32767 as smallint) from db_root; 
select timestamp'01/19/2038 12:14:07 pm' + 32768 from db_root; 
select timestamp '01/19/2038 12:14:06 pm' - cast(-2 as int) from db_root;
