--+ server-message on
-- error: an argument for an OUT or IN OUT parameter of CALL must be a host variable (CBRD-25140)
-- A constant, an expression, a session variable or a function call has no place for the returned value.
-- It fails with -1392 before the arguments are evaluated, so the procedure does not run.

create or replace procedure t25140_out (a OUT int) as begin a := 7; end;
create or replace procedure t25140_inout (a INOUT int) as begin a := nvl (a, -1) + 100; end;
create or replace procedure t25140_out2 (a IN int, b OUT int) as begin b := a * 2; end;
create or replace procedure t25140_oo (a OUT int, b OUT int) as begin a := 1; b := 2; end;
create or replace function t25140_fout (a OUT int) return int as begin a := 7; return 1; end;
create or replace function t25140_fn return int as begin return 1; end;

-- constant, NULL, expression, subquery, function and stored function
call t25140_out (77);
call t25140_inout (5);
call t25140_out (null);
call t25140_out (1 + 2);
call t25140_out ((select 1 from db_root));
call t25140_out (abs (-3));
call t25140_out (t25140_fn ());

-- a session variable is rejected and keeps its value
set @s25140 = 0;
call t25140_out (@s25140);
call t25140_inout (@s25140);
select @s25140 from db_root;

-- the message names the position of the argument
call t25140_out2 (3, 9);
call t25140_oo (1, 2);

-- a function called by CALL ... INTO
call t25140_fout (5) into :r25140;

-- a constant whose type does not match is rejected before the conversion
call t25140_out ('abc');

drop procedure t25140_out;
drop procedure t25140_inout;
drop procedure t25140_out2;
drop procedure t25140_oo;
drop function t25140_fout;
drop function t25140_fn;

--+ server-message off
