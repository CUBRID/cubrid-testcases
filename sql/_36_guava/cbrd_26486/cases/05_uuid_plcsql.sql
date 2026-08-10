/**
 *  This test case verifies CBRD-26486: UUID()/SYS_GUID()/UUID_FORMAT() in PL/CSQL.
 *  - SYS_GUID() as parameter / local variable / constant default
 *  - UUID_FORMAT(UUID(7)) inside cursors and SELECT INTO
 *  - local (nested) procedures and recursion
 *  - catalog (_db_stored_procedure_args) exposes the default expression
 *  - unsupported usages raise compile errors
 *
 *  NOTE: Generated UUID values differ on every execution, so dbms_output prints
 *  only derived checks (length / version nibble / pattern booleans).
 *  Since PL/CSQL does not support the BIT data type, the UUID function 
 *  cannot be used as a DEFAULT value within it.
 */

--+ server-message on

evaluate '[TEST 1] SYS_GUID defaults for parameters, locals, constants; UUID_FORMAT(UUID(7)) in cursor and SELECT INTO';
create or replace procedure uuid_sp (n int, a string default sys_guid(), b string default sys_guid())
as
    c string default sys_guid();
    d string;
    e constant varchar := sys_guid();
    cursor cur is select uuid_format(uuid(7));
    cur_val string;

    procedure uuid_sp_son (m int, sa string default sys_guid())
    as
        sc string default sys_guid();
        sd string;
        cursor scur is select uuid_format(uuid(7));
        scur_val string;
    begin
        open scur;
        fetch scur into scur_val;
        select uuid_format(uuid(7)) into sd;
        dbms_output.put_line(' - (m=' || m || ') sa_hex=' || regexp_like(sa, '^[0-9A-F]{32}$', 'c')
            || ' sc_hex=' || regexp_like(sc, '^[0-9A-F]{32}$', 'c')
            || ' sd_v=' || substr(sd, 15, 1)
            || ' scur_v=' || substr(scur_val, 15, 1));
        if m > 0 then
            uuid_sp_son(m - 1, sa);
        end if;
        close scur;
    end;
begin
    open cur;
    fetch cur into cur_val;
    select uuid_format(uuid(7)) into d;
    dbms_output.put_line('(n=' || n || ') a_len=' || length(a)
        || ' b_len=' || length(b)
        || ' c_len=' || length(c)
        || ' e_hex=' || regexp_like(e, '^[0-9A-F]{32}$', 'c')
        || ' d_fmt=' || regexp_like(d, '^[0-9A-F]{8}-[0-9A-F]{4}-7[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$', 'c')
        || ' cur_v=' || substr(cur_val, 15, 1)
        || ' a_eq_b=' || decode(a, b, 1, 0));
    if n > 0 then
        uuid_sp_son(n);
        uuid_sp(n - 1, a);
    end if;
    close cur;
end;

call uuid_sp(2);
call uuid_sp(1, sys_guid());
call uuid_sp(0, '0123456789ABCDEF0123456789ABCDEF', '0123456789ABCDEF0123456789ABCDEF');

evaluate '[TEST 2] catalog exposes SYS_GUID() default expression of parameters';
select sp_of.sp_name, arg_name, mode, default_value
from _db_stored_procedure_args
where sp_of.sp_name = 'uuid_sp'
order by index_of;

drop procedure uuid_sp;

evaluate '[TEST 3] stored function returning a formatted UUID';
create or replace function uuid_sf return string
as
    v string;
begin
    select uuid_format(uuid(7)) into v;
    return v;
end;

select regexp_like(uuid_sf(), '^[0-9A-F]{8}-[0-9A-F]{4}-7[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$', 'c') sf_fmt;
select uuid_sf() = uuid_sf() sf_same;
drop function uuid_sf;

evaluate '[TEST 4] DML with UUID defaults inside a procedure';
drop table if exists uuid_sp_t;
create table uuid_sp_t (id bit(128) default uuid(7), g char(32) default sys_guid(), v int);
create or replace procedure uuid_sp_dml
as
begin
    insert into uuid_sp_t(v) values (1);
    insert into uuid_sp_t(v) values (2);
    insert into uuid_sp_t values (default, default, 3);
    update uuid_sp_t set g = sys_guid() where v = 1;
end;

call uuid_sp_dml();
select count(*) total, count(distinct id) id_uniq, count(distinct g) g_uniq,
       count(case when substr(uuid_format(id), 15, 1) = '7' then 1 end) id_is_v7,
       count(case when regexp_like(g, '^[0-9A-F]{32}$', 'c') = 1 then 1 end) g_is_hex
from uuid_sp_t;
drop procedure uuid_sp_dml;
drop table uuid_sp_t;

evaluate '[TEST 5] unsupported usages -> error';
-- Each negative case uses a distinct name and a catalog check confirms none was
-- created (DROP PROCEDURE IF EXISTS is not supported, so isolation relies on distinct
-- names; wrongly_created must be 0, exposing any case that compiled by mistake).
create or replace procedure uuid_sp_e1 (a string default uuid(7)) as begin return; end;
create or replace procedure uuid_sp_e2 (a string default to_char(uuid())) as begin return; end;
create or replace procedure uuid_sp_e3 as c string default uuid_format(uuid(7)); begin return; end;
select count(*) wrongly_created from _db_stored_procedure where sp_name in ('uuid_sp_e1', 'uuid_sp_e2', 'uuid_sp_e3');

evaluate '[TEST 6] pass UUID as a stringified / UUID_FORMAT-wrapped procedure argument';
-- A BIT(128) UUID cannot be passed to a PL/CSQL string parameter directly, so it must
-- be stringified (CAST ... AS STRING -> 32 lowercase hex) or wrapped with UUID_FORMAT
-- (-> 36-char canonical). The procedure re-normalizes the argument with UUID_FORMAT
-- to read the version nibble regardless of which form was passed.
create or replace procedure uuid_arg_sp (a string, expected_ver char)
as
begin
    dbms_output.put_line('in_len=' || length(a)
        || ' reformat_ver=' || substr(uuid_format(a), 15, 1)
        || ' fmt_ok=' || regexp_like(uuid_format(a), '^[0-9A-F]{8}-[0-9A-F]{4}-[47][0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$', 'c')
        || ' ver_match=' || decode(substr(uuid_format(a), 15, 1), expected_ver, 1, 0));
end;

evaluate '[TEST 6.1] UUID_FORMAT-wrapped arguments (36-char canonical)';
call uuid_arg_sp(uuid_format(uuid(7)), '7');
call uuid_arg_sp(uuid_format(uuid(4)), '4');
call uuid_arg_sp(uuid_format(uuid()), '4');
call uuid_arg_sp(uuid_format(sys_guid()), '4');

evaluate '[TEST 6.2] stringified arguments (CAST AS STRING -> 32 hex)';
call uuid_arg_sp(cast(uuid(7) as string), '7');
call uuid_arg_sp(cast(uuid(4) as string), '4');
call uuid_arg_sp(cast(uuid() as varchar), '4');
call uuid_arg_sp(sys_guid(), '4');

evaluate '[TEST 6.3] raw BIT UUID argument -> error (PL/CSQL does not accept BIT arguments)';
call uuid_arg_sp(uuid(7), '7');
call uuid_arg_sp(uuid(4), '4');
drop procedure uuid_arg_sp;

evaluate '[TEST 7] stored function takes a stringified/formatted UUID argument and re-formats it';
create or replace function uuid_norm_fn (a string) return string
as
begin
    return uuid_format(a);
end;

select regexp_like(uuid_norm_fn(cast(uuid(7) as string)), '^[0-9A-F]{8}-[0-9A-F]{4}-7[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$', 'c') v7_from_stringified,
       regexp_like(uuid_norm_fn(uuid_format(uuid(4))), '^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$', 'c') v4_from_formatted,
       regexp_like(uuid_norm_fn(sys_guid()), '^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$', 'c') v4_from_sysguid;
evaluate '[TEST 7.1] UUID_FORMAT is idempotent through the function round-trip';
select uuid_norm_fn('0123456789ABCDEF0123456789ABCDEF') from_hex,
       uuid_norm_fn('01234567-89ab-cdef-0123-456789abcdef') from_formatted;
drop function uuid_norm_fn;

--+ server-message off
