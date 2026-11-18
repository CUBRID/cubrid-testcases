/**
 *  This test case verifies CBRD-28189: a USING value of EXECUTE IMMEDIATE that goes to an OUT or
 *  IN OUT parameter of a CALL in the dynamic SQL
 *
 *  Before the fix, the CALL ran and the value that the procedure returned was dropped with no error,
 *  so the variable kept its old value. Now the CALL fails with a semantic error that says the argument
 *  is bound as an IN value by the USING clause, and the procedure does not run. Each case writes the
 *  variable and SQLERRM into t28189_log, and a SELECT prints the rows.
 *
 *  Coverage:
 *    Case 1:  an uncaught refusal fails the outer CALL, and the procedure writes no row
 *    Case 2:  the refusal of an OUT parameter is caught by WHEN OTHERS, and the variable keeps 3
 *    Case 3:  an IN OUT parameter is refused too, with USING and with USING IN
 *    Case 4:  IN and OUT arguments in one CALL - only argument 2, the OUT one, is refused
 *    Case 5:  a dynamic SQL built by concatenation is refused too
 *    Case 6:  upper case, an owner prefix, a quoted name, two OUT parameters, USING NULL, and a bind
 *             value before a constant are all refused at argument 1
 */

drop table if exists t28189_log;
create table t28189_log (seq int auto_increment primary key, tag varchar (20), v int, msg varchar (1000));
create or replace procedure t28189_out (a OUT int) as begin a := 7; end;
create or replace procedure t28189_inout (a INOUT int) as begin a := a + 1; end;
create or replace procedure t28189_q (a IN int, b OUT int) as begin b := a * 10; end;
create or replace procedure t28189_oo (a OUT int, b OUT int) as begin a := 7; b := 8; end;

evaluate 'Case 1: an uncaught refusal fails the outer CALL, and the procedure writes no row';
create or replace procedure t28189_p1 as
    l_j int := 3;
begin
    execute immediate 'call t28189_out(?)' using l_j;
    insert into t28189_log (tag, v) values ('j', l_j);
end;
call t28189_p1 ();
select tag, v from t28189_log order by seq;

evaluate 'Case 2: the refusal of an OUT parameter is caught by WHEN OTHERS, and the variable keeps 3';
delete from t28189_log;
create or replace procedure t28189_p2 as
    l_j int := 3;
    l_e varchar (1000);
begin
    execute immediate 'call t28189_out(?)' using l_j;
    insert into t28189_log (tag, v) values ('j', l_j);
exception
    when others then
        l_e := SQLERRM;
        insert into t28189_log (tag, v, msg) values ('caught', l_j, l_e);
end;
call t28189_p2 ();
select tag, v, msg from t28189_log order by seq;

evaluate 'Case 3: an IN OUT parameter is refused too, with USING and with USING IN';
delete from t28189_log;
create or replace procedure t28189_p3 as
    l_j int := 3;
    l_e varchar (1000);
begin
    begin
        execute immediate 'call t28189_inout(?)' using l_j;
        insert into t28189_log (tag, v) values ('j', l_j);
    exception
        when others then
            l_e := SQLERRM;
            insert into t28189_log (tag, v, msg) values ('caught', l_j, l_e);
    end;
    begin
        execute immediate 'call t28189_inout(?)' using in l_j;
        insert into t28189_log (tag, v) values ('j_in', l_j);
    exception
        when others then
            l_e := SQLERRM;
            insert into t28189_log (tag, v, msg) values ('caught_in', l_j, l_e);
    end;
end;
call t28189_p3 ();
select tag, v, msg from t28189_log order by seq;

evaluate 'Case 4: IN and OUT arguments in one CALL - only argument 2, the OUT one, is refused';
delete from t28189_log;
create or replace procedure t28189_p4 as
    l_j int := 3;
    l_e varchar (1000);
begin
    execute immediate 'call t28189_q(?, ?)' using 1, l_j;
    insert into t28189_log (tag, v) values ('j', l_j);
exception
    when others then
        l_e := SQLERRM;
        insert into t28189_log (tag, v, msg) values ('caught', l_j, l_e);
end;
call t28189_p4 ();
select tag, v, msg from t28189_log order by seq;

evaluate 'Case 5: a dynamic SQL built by concatenation is refused too';
delete from t28189_log;
create or replace procedure t28189_p5 as
    l_j int := 3;
    l_s varchar (100);
    l_e varchar (1000);
begin
    l_s := 'call ' || 't28189_out' || '(?)';
    execute immediate l_s using l_j;
    insert into t28189_log (tag, v) values ('j', l_j);
exception
    when others then
        l_e := SQLERRM;
        insert into t28189_log (tag, v, msg) values ('caught', l_j, l_e);
end;
call t28189_p5 ();
select tag, v, msg from t28189_log order by seq;

evaluate 'Case 6: upper case, an owner prefix, a quoted name, two OUT parameters, USING NULL, and a bind value before a constant are all refused at argument 1';
delete from t28189_log;
-- v is the variable after the call: l_j * 10 + l_k for two_out, 1 for using_null, which binds no variable
create or replace procedure t28189_p6 as
    l_j int;
    l_k int;
    l_e varchar (1000);
    procedure run_one (p_cell varchar, p_sql varchar) as
    begin
        l_j := 3;
        begin
            execute immediate p_sql using l_j;
            insert into t28189_log (tag, v) values (p_cell, l_j);
        exception
            when others then
                l_e := SQLERRM;
                insert into t28189_log (tag, v, msg) values (p_cell, l_j, l_e);
        end;
    end;
begin
    run_one ('upper', 'CALL T28189_OUT(?)');
    run_one ('owner', 'call dba.t28189_out(?)');
    run_one ('quoted', 'call "t28189_out"(?)');
    run_one ('bind_first', 'call t28189_oo(?, 7)');
    l_j := 3;
    l_k := 4;
    begin
        execute immediate 'call t28189_oo(?, ?)' using l_j, l_k;
        insert into t28189_log (tag, v) values ('two_out', l_j * 10 + l_k);
    exception
        when others then
            l_e := SQLERRM;
            insert into t28189_log (tag, v, msg) values ('two_out', l_j * 10 + l_k, l_e);
    end;
    begin
        execute immediate 'call t28189_out(?)' using null;
        insert into t28189_log (tag, v) values ('using_null', 1);
    exception
        when others then
            l_e := SQLERRM;
            insert into t28189_log (tag, v, msg) values ('using_null', 1, l_e);
    end;
end;
call t28189_p6 ();
select tag, v, msg from t28189_log order by seq;

drop procedure t28189_p1;
drop procedure t28189_p2;
drop procedure t28189_p3;
drop procedure t28189_p4;
drop procedure t28189_p5;
drop procedure t28189_p6;
drop procedure t28189_out;
drop procedure t28189_inout;
drop procedure t28189_q;
drop procedure t28189_oo;
drop table t28189_log;
