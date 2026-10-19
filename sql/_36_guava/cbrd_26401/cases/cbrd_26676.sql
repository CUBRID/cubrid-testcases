/**
 * This test case verifies CBRD-26676: the default_value catalog column is
 * widened from 255 to DB_MAX_DEFAULT_EXPR_LENGTH (2048)
 *
 * Coverage:
 * 1   - db_attribute/_db_attribute.default_value column width is 2048
 * 2-3 - a 256/2048-char table column DEFAULT round-trips in full through
 *       db_attribute.default_value; 3 also cross-checks against _db_attribute
 * 4   - a 2049-char DEFAULT is accepted, but the catalog display truncates
 *       to 2048 while the stored value keeps its full length
 * 5   - db_stored_procedure_args/_db_stored_procedure_args.default_value
 *       column width is 2048
 * 6   - a 2048-char PL/CSQL parameter DEFAULT round-trips in full through
 *       db_stored_procedure_args.default_value
 * 7   - the catalog's 2048 limit is in characters: a 2048-char multibyte
 *       DEFAULT (6144 bytes) is not truncated
 * 8-9 - PL/CSQL's 2048 limit is in bytes instead: a 682-char (2046-byte)
 *       multibyte default is accepted, but 683-char (2049-byte) is rejected
 */

evaluate 'Case 1: db_attribute/_db_attribute default_value column width is 2048';
select class_name, prec from db_attribute
where class_name in ('db_attribute', '_db_attribute') and attr_name = 'default_value'
order by class_name;

drop table if exists t1;
create table t1 (c1 int, c2 varchar(3000) default rpad('a', 256, 'a'));

evaluate 'Case 2: a 256-char table column DEFAULT round-trips in full through db_attribute.default_value';
select char_length(default_value) from db_attribute where class_name = 't1' and attr_name = 'c2';

drop table if exists t2;
create table t2 (c1 int, c2 varchar(3000) default rpad('a', 2048, 'a'));

evaluate 'Case 3: a 2048-char table column DEFAULT round-trips in full through db_attribute.default_value, and db_attribute/_db_attribute agree on the value';
select char_length(default_value), default_value from db_attribute where class_name = 't2' and attr_name = 'c2';
select
    (select default_value from db_attribute where class_name = 't2' and attr_name = 'c2')
    = (select default_value from _db_attribute where class_of.class_name = 't2' and attr_name = 'c2');

drop table if exists t3;
create table t3 (c1 int, c2 varchar(3000) default rpad('a', 2049, 'a'));

evaluate 'Case 4: a 2049-char DEFAULT is accepted, but the catalog display truncates to 2048 while the real default value keeps its full length';
select char_length(default_value), default_value from db_attribute where class_name = 't3' and attr_name = 'c2';
insert into t3 (c1) values (1);
select char_length(c2), c2 from t3;

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

evaluate 'Case 5: db_stored_procedure_args/_db_stored_procedure_args default_value column width is 2048';
select class_name, prec from db_attribute
where class_name in ('db_stored_procedure_args', '_db_stored_procedure_args') and attr_name = 'default_value'
order by class_name;

create or replace procedure default_value_proc (a in varchar := rpad('a', 2048, 'a')) as
begin
    DBMS_OUTPUT.put_line(length(a));
end;

evaluate 'Case 6: a PL/CSQL parameter DEFAULT of exactly 2048 chars round-trips in full through db_stored_procedure_args.default_value';
select char_length(default_value), default_value from db_stored_procedure_args where sp_name = 'default_value_proc' and arg_name = 'a';

drop procedure default_value_proc;

drop table if exists t4;
create table t4 (c1 int, c2 varchar(3000) default rpad('가', 2048, '가'));

evaluate 'Case 7: the catalog 2048 limit is measured in characters, not bytes - a 2048-char multibyte DEFAULT is not truncated even though it is 6144 bytes';
select char_length(default_value), octet_length(default_value) from db_attribute where class_name = 't4' and attr_name = 'c2';

drop table if exists t4;

evaluate 'Case 8: unlike the catalog, PL/CSQL enforces its 2048 limit in bytes - a 682-char (2046-byte) multibyte default, just under the byte limit, is accepted';
create or replace procedure mb_default_under (a in varchar := rpad('가', 682, '가')) as
begin
    DBMS_OUTPUT.put_line(length(a));
end;

select char_length(default_value), octet_length(default_value) from db_stored_procedure_args where sp_name = 'mb_default_under' and arg_name = 'a';

drop procedure mb_default_under;

evaluate 'Case 9: a 683-char (2049-byte) multibyte default, just over the byte limit, is rejected even though its character count (683) is nowhere near 2048';
create or replace procedure mb_default_over (a in varchar := rpad('가', 683, '가')) as
begin
    DBMS_OUTPUT.put_line(length(a));
end;

-- error call
call mb_default_over();

--error drop
drop procedure mb_default_over;
