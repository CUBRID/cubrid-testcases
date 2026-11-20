/**
 *  This test case verifies CBRD-28189: the refusal of a USING value at an OUT parameter in the
 *  contexts around EXECUTE IMMEDIATE
 *
 *  A USING value of EXECUTE IMMEDIATE that goes to an OUT or IN OUT parameter of a CALL in the dynamic
 *  SQL is refused. The cases below check that the refusal holds in a loop with COMMIT, after a change
 *  of the target procedure, in a trigger action, for a user other than DBA, and under
 *  hostvar_late_binding=yes, and that it does not leave the statements before it. Each case writes
 *  what it sees into a log table, and a SELECT prints the rows.
 *
 *  Coverage:
 *    Case 1:  the same statement in a loop with a COMMIT each time is refused on every pass
 *    Case 2:  a refusal after an INSERT fails the outer CALL and leaves no row, as a syntax error does
 *    Case 3:  a target procedure changed from IN to OUT and committed is refused on the next run
 *    Case 4:  a refusal in a procedure that a trigger action calls fails the INSERT that fired it
 *    Case 5:  a user other than DBA is refused at an own procedure, with the owner in the message
 *    Case 6:  a user without the EXECUTE privilege gets the authorization error first
 *    Case 7:  the refusal holds under hostvar_late_binding=yes, and an IN parameter still runs
 */

drop table if exists t28189_log;
create table t28189_log (seq int auto_increment primary key, tag varchar (20), v int, msg varchar (1000));
create or replace procedure t28189_out (a OUT int) as begin a := 7; end;
create or replace procedure t28189_in (a IN int) as begin insert into t28189_log (tag, v) values ('in', a); end;

evaluate 'Case 1: the same statement in a loop with a COMMIT each time is refused on every pass';
-- a COMMIT inside a PL/CSQL procedure runs whatever pl_transaction_control is set to
create or replace procedure t28189_p1 as
    l_j int;
begin
    for i in 1 .. 3 loop
        l_j := 3;
        begin
            execute immediate 'call t28189_out(?)' using l_j;
            insert into t28189_log (tag, v) values ('j', l_j);
        exception
            when others then
                insert into t28189_log (tag, v) values ('caught', i);
        end;
        commit;
    end loop;
end;
call t28189_p1 ();
select tag, v from t28189_log order by seq;

evaluate 'Case 2: a refusal after an INSERT fails the outer CALL and leaves no row, as a syntax error does';
delete from t28189_log;
-- t28189_p2b is the control: its dynamic SQL has a syntax error
create or replace procedure t28189_p2a as
    l_j int := 3;
begin
    insert into t28189_log (tag, v) values ('a_before', 1);
    execute immediate 'call t28189_out(?)' using l_j;
    insert into t28189_log (tag, v) values ('a_after', l_j);
end;
create or replace procedure t28189_p2b as
    l_j int := 3;
begin
    insert into t28189_log (tag, v) values ('b_before', 1);
    execute immediate 'call t28189_out(?' using l_j;
    insert into t28189_log (tag, v) values ('b_after', l_j);
end;
call t28189_p2a ();
call t28189_p2b ();
select tag, v from t28189_log order by seq;

evaluate 'Case 3: a target procedure changed from IN to OUT and committed is refused on the next run';
delete from t28189_log;
-- the first pass calls t28189_tgt with an IN parameter, then the procedure redefines it with an OUT
-- parameter and commits, and the second pass runs the same statement text again
create or replace procedure t28189_tgt (a IN int) as begin insert into t28189_log (tag, v) values ('tgt_in', a); end;
create or replace procedure t28189_p3 as
    l_j int;
    l_e varchar (1000);
begin
    for i in 1 .. 2 loop
        l_j := 3;
        begin
            execute immediate 'call t28189_tgt(?)' using l_j;
            insert into t28189_log (tag, v) values ('ok', i * 10 + l_j);
        exception
            when others then
                l_e := SQLERRM;
                insert into t28189_log (tag, v, msg) values ('caught', i * 10 + l_j, l_e);
        end;
        if i = 1 then
            execute immediate 'create or replace procedure t28189_tgt (a OUT int) as begin a := 7; end';
            commit;
        end if;
    end loop;
end;
call t28189_p3 ();
select tag, v, msg from t28189_log order by seq;

evaluate 'Case 4: a refusal in a procedure that a trigger action calls fails the INSERT that fired it';
delete from t28189_log;
drop table if exists t28189_tt;
create table t28189_tt (a int);
create or replace procedure t28189_p4 as
    l_j int := 3;
begin
    execute immediate 'call t28189_out(?)' using l_j;
    insert into t28189_log (tag, v) values ('j', l_j);
end;
create trigger t28189_trg after insert on t28189_tt execute call t28189_p4 ();
insert into t28189_tt values (1);
select a from t28189_tt order by a;
select tag, v from t28189_log order by seq;

-- Case 5 and Case 6 run as u28189, which owns its log table and procedures and has no privilege on
-- the objects of DBA
create user u28189;
--+ holdcas on;
call login ('u28189', '') on class db_user;
drop table if exists t28189_ulog;
create table t28189_ulog (seq int auto_increment primary key, tag varchar (20), v int, msg varchar (1000));
create or replace procedure t28189_uout (a OUT int) as begin a := 7; end;

evaluate 'Case 5: a user other than DBA is refused at an own procedure, with the owner in the message';
create or replace procedure t28189_p5 as
    l_j int := 3;
    l_e varchar (1000);
begin
    execute immediate 'call t28189_uout(?)' using l_j;
    insert into t28189_ulog (tag, v) values ('j', l_j);
exception
    when others then
        l_e := SQLERRM;
        insert into t28189_ulog (tag, v, msg) values ('caught', l_j, l_e);
end;
call t28189_p5 ();
select tag, v, msg from t28189_ulog order by seq;

evaluate 'Case 6: a user without the EXECUTE privilege gets the authorization error first';
delete from t28189_ulog;
create or replace procedure t28189_p6 as
    l_j int := 3;
    l_e varchar (1000);
begin
    execute immediate 'call dba.t28189_out(?)' using l_j;
    insert into t28189_ulog (tag, v) values ('j', l_j);
exception
    when others then
        l_e := SQLERRM;
        insert into t28189_ulog (tag, v, msg) values ('caught', l_j, l_e);
end;
call t28189_p6 ();
select tag, v, msg from t28189_ulog order by seq;

drop procedure t28189_p5;
drop procedure t28189_p6;
drop procedure t28189_uout;
drop table t28189_ulog;
call login ('dba', '') on class db_user;
--+ holdcas off;
drop user u28189;

evaluate 'Case 7: the refusal holds under hostvar_late_binding=yes, and an IN parameter still runs';
delete from t28189_log;
-- no static OUT call here: under hostvar_late_binding=yes it returns NULL on develop too, which this TC does not check
set system parameters 'hostvar_late_binding=yes';
create or replace procedure t28189_p7 as
    l_j int;
    l_e varchar (1000);
begin
    l_j := 3;
    begin
        execute immediate 'call t28189_out(?)' using l_j;
        insert into t28189_log (tag, v) values ('out', l_j);
    exception
        when others then
            l_e := SQLERRM;
            insert into t28189_log (tag, v, msg) values ('out', l_j, l_e);
    end;
    l_j := 4;
    execute immediate 'call t28189_in(?)' using l_j;
end;
call t28189_p7 ();
select tag, v, msg from t28189_log order by seq;
set system parameters 'hostvar_late_binding=default';

drop trigger t28189_trg;
drop table t28189_tt;
drop procedure t28189_p1;
drop procedure t28189_p2a;
drop procedure t28189_p2b;
drop procedure t28189_p3;
drop procedure t28189_tgt;
drop procedure t28189_p4;
drop procedure t28189_p7;
drop procedure t28189_out;
drop procedure t28189_in;
drop table t28189_log;
