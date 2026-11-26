/**
 *  This test case verifies CBRD-25140: a host variable still takes the value of an OUT or IN OUT
 *  parameter
 *
 *  A csql host variable is a bind variable, so it is accepted at an OUT or IN OUT parameter and gets
 *  the value back. A JDBC bind is checked in the private-ex shell test cbrd_25140. A value of a
 *  SQL-level EXECUTE with USING is refused at an OUT parameter since CBRD-28189, which
 *  02_01_05-21_error_OUT_arg_sql_execute_using checks.
 *
 *  Coverage:
 *    Case 1:  a host variable gets the value of OUT, IN OUT, and IN and OUT parameters, and of a function
 *    Case 2:  a function with an OUT parameter in an expression fails with the existing error
 */

--+ server-message on

create or replace procedure t25140_out (a OUT int) as begin a := 7; end;
create or replace procedure t25140_inout (a INOUT int) as begin a := nvl (a, -1) + 100; end;
create or replace procedure t25140_out2 (a IN int, b OUT int) as begin b := a * 2; end;
create or replace function t25140_fout (a OUT int) return int as begin a := 7; return 1; end;

evaluate 'Case 1: a host variable gets the value of OUT, IN OUT, and IN and OUT parameters, and of a function';
select 0 into :h25140 from db_root;
call t25140_out (:h25140);
select :h25140 from db_root;
call t25140_inout (:h25140);
select :h25140 from db_root;
call t25140_out2 (3, :h25140);
select :h25140 from db_root;
select 0 into :r25140 from db_root;
call t25140_fout (:h25140) into :r25140;
select :h25140, :r25140 from db_root;

evaluate 'Case 2: a function with an OUT parameter in an expression fails with the existing error';
select t25140_fout (:h25140) from db_root;

drop procedure t25140_out;
drop procedure t25140_inout;
drop procedure t25140_out2;
drop function t25140_fout;

--+ server-message off
