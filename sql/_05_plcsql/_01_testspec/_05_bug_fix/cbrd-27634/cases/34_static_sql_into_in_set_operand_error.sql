-- verified the CBRD-27634
evaluate 'SELECT INTO in an operand of UNION / INTERSECT / EXCEPT of a static SQL is a compile error (semantic error 344).';
evaluate 'INTO variables of PL/CSQL can receive only the final result of a query.';

--+ server-message on

drop table if exists so_t1, so_t2;
create table so_t1 (a int);
create table so_t2 (a int);
insert into so_t1 values (1), (2);
insert into so_t2 values (2), (3);

evaluate 'error: INTO in the left operand of UNION';
create or replace procedure so_e1 as
    x int;
begin
    select a into x from so_t1 where a = 1 union select a from so_t2 where a = 3;
    dbms_output.put_line(x);
end;

evaluate 'error: INTO in the right operand of UNION';
create or replace procedure so_e2 as
    x int;
begin
    select a from so_t1 where a = 1 union select a into x from so_t2 where a = 3;
    dbms_output.put_line(x);
end;

evaluate 'error: INTO in both operands of UNION';
create or replace procedure so_e3 as
    x int;
begin
    select a into x from so_t1 where a = 1 union select a into x from so_t2 where a = 3;
end;

evaluate 'error: INTO in a nested left operand (UNION ALL and UNION chained)';
create or replace procedure so_e4 as
    x int;
begin
    select a into x from so_t1 where a = 1 union all select a from so_t2 where a = 3 union select a from so_t2 where a = 9;
end;

evaluate 'error: INTO in a nested right operand (INTERSECT inside UNION ALL)';
create or replace procedure so_e5 as
    x int;
begin
    select a from so_t1 where a = 1 union all (select a from so_t2 where a = 3 intersect select a into x from so_t2);
end;

evaluate 'error: INTO in an operand of INTERSECT';
create or replace procedure so_e6 as
    x int;
begin
    select a into x from so_t1 where a = 1 intersect select a from so_t2;
end;

evaluate 'error: INTO in an operand of EXCEPT';
create or replace procedure so_e7 as
    x int;
begin
    select a into x from so_t1 where a = 1 except select a from so_t2;
end;

evaluate 'error: INTO in an operand of UNION in a derived table';
create or replace procedure so_e8 as
    x int;
begin
    select max(a) into x from (select a into x from so_t1 union select a from so_t2);
end;

evaluate 'error: INTO in an operand of UNION in a function';
create or replace function so_e9 return int as
    x int;
begin
    select a into x from so_t1 where a = 1 union select a from so_t2 where a = 3;
    return x;
end;

evaluate 'the routines above must not be created';
call so_e1();
select so_e9() from dual;

drop table so_t1, so_t2;

--+ server-message off
