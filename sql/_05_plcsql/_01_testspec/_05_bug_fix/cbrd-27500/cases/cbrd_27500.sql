-- verified the CBRD-27500
evaluate 'a PL/CSQL variable as the first argument of FIELD in a static SQL.';
evaluate 'the parser copies the first argument of FIELD into each comparison, and each copy of the variable got its own';
evaluate 'host variable: the rewritten query kept only one of them and the call failed with a missing bind variable.';

--+ server-message on

drop table if exists t351, tf;
create table t351 (i int);
insert into t351 values (1), (2);
create table tf (i int, s varchar (10));
insert into tf values (1, 'a'), (2, 'b'), (3, 'c');

evaluate 'the repro of the issue: FIELD';
create or replace procedure p351_field () as
    v int := 2;
    r varchar;
begin
    select field (v, 1, 2, 3) into r from dual;
    dbms_output.put_line (r);
end;
call p351_field ();

evaluate 'the repro of the issue: LIMIT of a derived table';
create or replace procedure p351_limit () as
    v_lim int := 1;
    k int;
begin
    select count (*) into k from (select i from t351 order by i limit v_lim) x;
    dbms_output.put_line (k);
end;
call p351_limit ();

evaluate 'variables in the first argument and in the list of FIELD';
create or replace function f_field2 (v int, w int) return int as
    r int;
begin
    select field (v, 1, w, 3) into r from dual;
    return r;
end;
select f_field2 (2, 3), f_field2 (3, 3), f_field2 (1, 9) from db_root;

evaluate 'FIELD with two arguments, in WHERE, and the same variable in two FIELD';
create or replace function f_field3 (v varchar) return varchar as
    n1 int;
    n2 int;
    n3 int;
begin
    select field (v, s) into n1 from tf where i = 2;
    select count (*) into n2 from tf where field (s, v, 'c') > 0;
    select field (v, 'a', 'b') + field (v, 'b') into n3 from dual;
    return n1 || '/' || n2 || '/' || n3;
end;
select f_field3 ('b') from db_root;

evaluate 'FIELD with the same variable outside of it';
create or replace function f_field4 (v int) return varchar as
    r varchar;
begin
    select s into r from tf where i = v and field (i, v, 9) = 1;
    return r;
end;
select f_field4 (2) from db_root;

evaluate 'the other functions whose argument the parser copies';
create or replace function f_copied (v int, sep varchar) return varchar as
    r1 varchar;
    r2 varchar;
    r3 varchar;
begin
    select case v when 1 then 'one' when 2 then 'two' else 'other' end into r1 from dual;
    select decode (v, 1, 'one', 2, 'two', 'other') into r2 from dual;
    select concat_ws (sep, 'a', 'b', 'c') into r3 from dual;
    return r1 || '/' || r2 || '/' || r3;
end;
select f_copied (2, '-') from db_root;

evaluate 'FIELD when the rewritten query is printed from the tree (WEEK without its mode)';
create or replace function f_field_tree (v int) return int as
    r int;
begin
    select field (v, 1, 2, 3) + week (date '2026-01-01') * 0 into r from dual;
    return r;
end;
select f_field_tree (2), f_field_tree (5) from db_root;

drop procedure p351_field;
drop procedure p351_limit;
drop function f_field2;
drop function f_field3;
drop function f_field4;
drop function f_copied;
drop function f_field_tree;
drop table t351, tf;
