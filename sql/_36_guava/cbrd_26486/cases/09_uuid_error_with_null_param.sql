/**
 *  This test case verifies CBRD-26572: UUID()/SYS_GUID()/UUID_FORMAT() still raise
 *  errors even when the system parameter return_null_on_function_errors is set.
 *  Unlike most built-in functions, the UUID family does not suppress its errors under
 *  this parameter -- an unsupported version, an invalid UUID_FORMAT input, or a
 *  NULL / non-numeric version argument all error, in both SELECT and INSERT contexts.
 *  Valid calls continue to produce normal values.
 *
 *  NOTE: raw UUID values never appear in the answer; only derived counts.
 *  return_null_on_function_errors is a session setting, restored to OFF at the end.
 */

evaluate '[TEST 1] enable return_null_on_function_errors';
set system parameters 'return_null_on_function_errors=yes';

evaluate '[TEST 2] unsupported version still errors (not NULL) under the parameter';
select uuid(1);
select uuid(5);
select uuid(8);
select uuid(-1);

evaluate '[TEST 3] invalid UUID_FORMAT input still errors under the parameter';
select uuid_format('zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz');
select uuid_format('short');
select uuid_format('0123456789abcdef0123456789abcde');

evaluate '[TEST 4] NULL / non-numeric version still errors under the parameter';
select uuid(null);
select uuid(cast(null as int));
select uuid('abc');
select uuid(4, 7);

evaluate '[TEST 5] valid calls still produce normal values under the parameter';
select bit_length(uuid()) u_def, bit_length(uuid(4)) u_v4, bit_length(uuid(7)) u_v7, char_length(sys_guid()) guid_len;
select substr(uuid_format(uuid(4)), 15, 1) v4, substr(uuid_format(uuid(7)), 15, 1) v7;
select uuid_format('0123456789abcdef0123456789abcdef') fmt_ok;

evaluate '[TEST 6] INSERT context: the error is raised, no NULL row is stored';
drop table if exists uuid_perr_t;
create table uuid_perr_t (a bit(128), g char(32));
insert into uuid_perr_t(a) values (uuid(5));
insert into uuid_perr_t(a) select uuid(8) from db_root;
insert into uuid_perr_t(g) values (uuid_format('zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'));
select count(*) total from uuid_perr_t;
drop table uuid_perr_t;

evaluate '[TEST 7] restore the parameter to OFF';
set system parameters 'return_null_on_function_errors=no';
