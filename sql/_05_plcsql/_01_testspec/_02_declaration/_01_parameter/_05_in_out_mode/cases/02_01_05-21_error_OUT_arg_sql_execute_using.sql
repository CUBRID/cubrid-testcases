/**
 *  This test case verifies CBRD-28189: the refusal of a USING value of a SQL-level EXECUTE at an OUT
 *  parameter
 *
 *  A SQL-level EXECUTE passes its USING values as values, so an OUT or IN OUT parameter of the
 *  prepared CALL has nowhere to return a value. The PREPARE succeeds, and the EXECUTE fails with a
 *  semantic error, because each EXECUTE compiles the statement text again. Cases 1, 2 and 4 run at the
 *  top level, where the answer shows the error code. Case 3 runs the same statements inside EXECUTE
 *  IMMEDIATE and writes SQLERRM into t28189_log. The procedures write a row when they run.
 *
 *  Coverage:
 *    Case 1:  EXECUTE with USING at an OUT parameter fails, and the procedure does not run
 *    Case 2:  EXECUTE with USING at an IN OUT parameter, and at the OUT one of an IN and OUT pair, fails
 *    Case 3:  SQL-level PREPARE and EXECUTE inside EXECUTE IMMEDIATE are refused with the message
 *    Case 4:  a target procedure changed from IN to OUT is refused at the next EXECUTE of the same name
 *    Case 5:  EXECUTE with USING at an IN parameter, and of an INSERT, still runs
 */

drop table if exists t28189_log;
create table t28189_log (seq int auto_increment primary key, tag varchar (20), v int, msg varchar (1000));
create or replace procedure t28189_out (a OUT int) as begin insert into t28189_log (tag) values ('out_ran'); a := 7; end;
create or replace procedure t28189_inout (a IN OUT int) as begin insert into t28189_log (tag, v) values ('inout_ran', a); a := a + 1; end;
create or replace procedure t28189_q (a IN int, b OUT int) as begin insert into t28189_log (tag, v) values ('q_ran', a); b := a; end;
create or replace procedure t28189_in (a IN int) as begin insert into t28189_log (tag, v) values ('in', a); end;

evaluate 'Case 1: EXECUTE with USING at an OUT parameter fails, and the procedure does not run';
prepare s28189_1 from 'call t28189_out(?)';
execute s28189_1 using 5;
select tag, v from t28189_log order by seq;
deallocate prepare s28189_1;

evaluate 'Case 2: EXECUTE with USING at an IN OUT parameter, and at the OUT one of an IN and OUT pair, fails';
prepare s28189_2a from 'call t28189_inout(?)';
execute s28189_2a using 5;
prepare s28189_2b from 'call t28189_q(?, ?)';
execute s28189_2b using 1, 2;
select tag, v from t28189_log order by seq;
deallocate prepare s28189_2a;
deallocate prepare s28189_2b;

evaluate 'Case 3: SQL-level PREPARE and EXECUTE inside EXECUTE IMMEDIATE are refused with the message';
create or replace procedure t28189_p3 as
    l_j int := 3;
    l_e varchar (1000);
begin
    execute immediate 'prepare s28189_3 from ''call t28189_out(?)''';
    execute immediate 'execute s28189_3 using 3';
    insert into t28189_log (tag, v) values ('j', l_j);
exception
    when others then
        l_e := SQLERRM;
        insert into t28189_log (tag, v, msg) values ('caught', l_j, l_e);
end;
call t28189_p3 ();
select tag, v, msg from t28189_log order by seq;
deallocate prepare s28189_3;

evaluate 'Case 4: a target procedure changed from IN to OUT is refused at the next EXECUTE of the same name';
delete from t28189_log;
create or replace procedure t28189_tgt (a IN int) as begin insert into t28189_log (tag, v) values ('tgt_in', a); end;
prepare s28189_4 from 'call t28189_tgt(?)';
execute s28189_4 using 1;
create or replace procedure t28189_tgt (a OUT int) as begin insert into t28189_log (tag) values ('tgt_out_ran'); a := 7; end;
execute s28189_4 using 2;
select tag, v from t28189_log order by seq;
deallocate prepare s28189_4;

evaluate 'Case 5: EXECUTE with USING at an IN parameter, and of an INSERT, still runs';
delete from t28189_log;
prepare s28189_5a from 'call t28189_in(?)';
execute s28189_5a using 9;
prepare s28189_5b from 'insert into t28189_log (tag, v) values (''ins'', ?)';
execute s28189_5b using 6;
select tag, v from t28189_log order by seq;
deallocate prepare s28189_5a;
deallocate prepare s28189_5b;

drop procedure t28189_p3;
drop procedure t28189_tgt;
drop procedure t28189_out;
drop procedure t28189_inout;
drop procedure t28189_q;
drop procedure t28189_in;
drop table t28189_log;
