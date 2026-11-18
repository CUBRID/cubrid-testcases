/**
 *  This test case verifies CBRD-28189: calls that the refusal of a USING value at an OUT parameter
 *  must leave as they were
 *
 *  CBRD-28189 refuses a USING value of EXECUTE IMMEDIATE that goes to an OUT or IN OUT parameter of a
 *  CALL in the dynamic SQL. The cases below run calls that do not take that path and must work as
 *  before. Each case writes what it sees into t28189_log, and a SELECT prints the rows.
 *
 *  Coverage:
 *    Case 1:  a USING value that goes only to an IN parameter runs the procedure
 *    Case 2:  a static PL/CSQL call returns the OUT and IN OUT values
 *    Case 3:  a static call inside a procedure that EXECUTE IMMEDIATE runs returns its OUT value
 *    Case 4:  a constant at an OUT parameter in EXECUTE IMMEDIATE keeps the CBRD-25140 error
 *    Case 5:  the same CALL text by EXECUTE IMMEDIATE and then by a static call - the first is
 *             refused and the second returns 7
 *    Case 6:  OPEN FOR with USING binds the value of a dynamic SELECT
 */

drop table if exists t28189_log;
create table t28189_log (seq int auto_increment primary key, tag varchar (20), v int, msg varchar (1000));
create or replace procedure t28189_out (a OUT int) as begin a := 7; end;
create or replace procedure t28189_inout (a INOUT int) as begin a := a + 1; end;
create or replace procedure t28189_in (a IN int) as begin insert into t28189_log (tag, v) values ('in', a); end;
create or replace procedure t28189_outer as
    l_j int := 3;
begin
    t28189_out (l_j);
    insert into t28189_log (tag, v) values ('outer', l_j);
end;

evaluate 'Case 1: a USING value that goes only to an IN parameter runs the procedure';
create or replace procedure t28189_p1 as
    l_j int := 3;
begin
    execute immediate 'call t28189_in(?)' using l_j;
    insert into t28189_log (tag, v) values ('after', 1);
end;
call t28189_p1 ();
select tag, v from t28189_log order by seq;

evaluate 'Case 2: a static PL/CSQL call returns the OUT and IN OUT values';
delete from t28189_log;
create or replace procedure t28189_p2 as
    l_j int := 3;
begin
    t28189_out (l_j);
    insert into t28189_log (tag, v) values ('out', l_j);
    l_j := 3;
    t28189_inout (l_j);
    insert into t28189_log (tag, v) values ('inout', l_j);
end;
call t28189_p2 ();
select tag, v from t28189_log order by seq;

evaluate 'Case 3: a static call inside a procedure that EXECUTE IMMEDIATE runs returns its OUT value';
delete from t28189_log;
create or replace procedure t28189_p3 as
begin
    execute immediate 'call t28189_outer()';
    insert into t28189_log (tag, v) values ('after', 1);
end;
call t28189_p3 ();
select tag, v from t28189_log order by seq;

evaluate 'Case 4: a constant at an OUT parameter in EXECUTE IMMEDIATE keeps the CBRD-25140 error';
delete from t28189_log;
create or replace procedure t28189_p4 as
    l_e varchar (1000);
begin
    execute immediate 'call t28189_out(7)';
    insert into t28189_log (tag, v) values ('after', 1);
exception
    when others then
        l_e := SQLERRM;
        insert into t28189_log (tag, v, msg) values ('caught', 1, l_e);
end;
call t28189_p4 ();
select tag, v, msg from t28189_log order by seq;

evaluate 'Case 5: the same CALL text by EXECUTE IMMEDIATE and then by a static call - the first is refused and the second returns 7';
delete from t28189_log;
-- PL/CSQL prepares the static call t28189_out (l_j) as the text CALL T28189_OUT(...), so the dynamic SQL uses
-- that text too: the two calls share one statement text, and the static call must not reuse the refused one.
-- The function returns -1 when the call is refused. The calls run in a procedure, not in a SELECT, because a
-- semantic error of a dynamic SQL in a function that a SELECT calls fails the SELECT before WHEN OTHERS.
create or replace function t28189_f5 (p_n int) return int as
    l_j int := 3;
begin
    if p_n = 1 then
        execute immediate 'call T28189_OUT(?)' using l_j;
    else
        t28189_out (l_j);
    end if;
    return l_j;
exception
    when others then
        return -1;
end;
create or replace procedure t28189_p5 as
    l_r int;
begin
    l_r := t28189_f5 (1);
    insert into t28189_log (tag, v) values ('first', l_r);
    l_r := t28189_f5 (2);
    insert into t28189_log (tag, v) values ('second', l_r);
end;
call t28189_p5 ();
select tag, v from t28189_log order by seq;

evaluate 'Case 6: OPEN FOR with USING binds the value of a dynamic SELECT';
delete from t28189_log;
create or replace procedure t28189_p6 as
    l_j int := 3;
    l_got int;
    l_c sys_refcursor;
begin
    open l_c for 'select ? from dual' using l_j;
    fetch l_c into l_got;
    close l_c;
    insert into t28189_log (tag, v) values ('got', l_got);
end;
call t28189_p6 ();
select tag, v from t28189_log order by seq;

drop procedure t28189_p1;
drop procedure t28189_p2;
drop procedure t28189_p3;
drop procedure t28189_p4;
drop procedure t28189_p5;
drop function t28189_f5;
drop procedure t28189_p6;
drop procedure t28189_outer;
drop procedure t28189_out;
drop procedure t28189_inout;
drop procedure t28189_in;
drop table t28189_log;
