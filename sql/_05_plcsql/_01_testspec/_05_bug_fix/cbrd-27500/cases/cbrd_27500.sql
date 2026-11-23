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

evaluate 'FIELD, DECODE and CASE comparing the variable with values of mixed types';
create or replace function f_mixed_field (v varchar) return int as
    r int;
begin
    select field (v, 1, 'a') into r from dual;
    return r;
end;
select f_mixed_field ('a'), f_mixed_field ('1'), f_mixed_field ('x') from db_root;
create or replace function f_mixed_decode (v int) return varchar as
    r varchar;
begin
    select decode (v, 1, 'x', 'a', 'y') into r from dual;
    return r;
end;
select f_mixed_decode (1) from db_root;
create or replace function f_mixed_decode_s (v varchar) return varchar as
    r varchar;
begin
    select decode (v, 1, 'x', 'a', 'y') into r from dual;
    return r;
end;
select f_mixed_decode_s ('1') from db_root;
evaluate 'a string compared with 1 is converted to double, as with a host variable or a literal in a SQL: error';
create or replace procedure p_mixed_case () as
    v varchar := 'a';
    r varchar;
begin
    select case v when 1 then 'int' when 'a' then 'str' end into r from dual;
    dbms_output.put_line (r);
end;
call p_mixed_case ();
select case 'a' when 1 then 'int' when 'a' then 'str' end from db_root;

evaluate 'a field of a record as the first argument of FIELD';
create or replace function f_field_rec return varchar as
    res varchar := '';
    x int;
begin
    for r in (select i from tf union all select 5 from db_root order by 1) loop
        select field (r.i, 1, 2, 3) into x from dual;
        res := res || x;
    end loop;
    return res;
end;
select f_field_rec () from db_root;

evaluate 'FIELD in GROUP BY and HAVING (the names there are made host variables after the aliases)';
create or replace function f_field_group (v int) return varchar as
    res varchar := '';
begin
    for r in (select field (v, i, 9) f, count (*) c from tf group by field (v, i, 9) order by 1) loop
        res := res || r.f || ':' || r.c || ' ';
    end loop;
    return res;
end;
select f_field_group (1), f_field_group (2) from db_root;
create or replace function f_field_having (v int) return int as
    n int;
begin
    select max (i) into n from tf group by i having field (v, i, 9) = 1;
    return n;
end;
select f_field_having (2), f_field_having (3) from db_root;

evaluate 'CONCAT_WS with a variable as the separator';
create or replace function f_concat_ws (sep varchar) return varchar as
    r varchar;
begin
    select concat_ws (sep, 'a', 'b', 'c') into r from dual;
    return r;
end;
select f_concat_ws ('-'), f_concat_ws (', ') from db_root;

evaluate 'FIELD in a derived table';
create or replace function f_field_derived (v int) return int as
    r int;
begin
    select * into r from (select field (v, 1, 2) f from dual) t;
    return r;
end;
select f_field_derived (2), f_field_derived (3) from db_root;

evaluate 'two variables in two FIELD get their own host variables';
create or replace function f_field_two (v int, w int) return int as
    r int;
begin
    select field (v, 1, 2) * 10 + field (w, 1, 2) into r from dual;
    return r;
end;
select f_field_two (1, 2), f_field_two (2, 1), f_field_two (2, 5) from db_root;

evaluate 'DML and UNION with the functions whose argument the parser copies';
drop table if exists td;
create table td (i int, s varchar (10));
insert into td values (1, 'a'), (2, 'b'), (3, 'c');
create or replace procedure p_dml_update (v int) as
begin
    update td set s = case v when 1 then 'x' else 'y' end where i = decode (v, 1, 1, 2);
end;
call p_dml_update (2);
select * from td order by 1, 2;
evaluate 'INSERT without a column list: the column list is also inserted in the text';
create or replace procedure p_dml_insert_select (v int) as
begin
    insert into td select field (v, 1, 2), 'z' from dual;
end;
create or replace procedure p_dml_insert_values (v int) as
begin
    insert into td values (field (v, 1, 2, 3) + 10, decode (v, 1, 'p', 'q'));
end;
call p_dml_insert_select (2);
call p_dml_insert_values (3);
select * from td order by 1, 2;
create or replace procedure p_dml_delete (v int) as
begin
    delete from td where field (i, v, 99) = 1 and s = 'z';
end;
call p_dml_delete (2);
select * from td order by 1, 2;
create or replace procedure p_dml_merge (v int) as
begin
    merge into td t using (select field (v, 1, 2) k from dual) s on (t.i = s.k)
    when matched then update set t.s = decode (v, 2, 'm', 'n')
    when not matched then insert values (s.k + 100, case v when 1 then 'one' else 'other' end);
end;
call p_dml_merge (2);
call p_dml_merge (5);
select * from td order by 1, 2;
create or replace function f_union (v int) return varchar as
    r varchar := '';
begin
    for x in (select field (v, 1, 2) a from dual
              union all
              select case v when 2 then 20 else 30 end from dual
              order by 1) loop
        r := r || x.a || ' ';
    end loop;
    return r;
end;
select f_union (2), f_union (1) from db_root;

drop procedure p351_field;
drop procedure p351_limit;
drop function f_field2;
drop function f_field3;
drop function f_field4;
drop function f_copied;
drop function f_field_tree;
drop procedure p_mixed_case;
drop function f_mixed_field;
drop function f_mixed_decode;
drop function f_mixed_decode_s;
drop function f_field_rec;
drop function f_field_group;
drop function f_field_having;
drop function f_concat_ws;
drop function f_field_derived;
drop function f_field_two;
drop procedure p_dml_update;
drop procedure p_dml_insert_select;
drop procedure p_dml_insert_values;
drop procedure p_dml_delete;
drop procedure p_dml_merge;
drop function f_union;
drop table t351, tf, td;
