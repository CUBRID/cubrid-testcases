--+ server-message on
-- normal: a host variable still takes the value of an OUT or IN OUT parameter (CBRD-25140)
-- A :name gets the value. A ? is accepted on every path. csql PREPARE is checked here, JDBC in the private-ex shell test cbrd_25140.

create or replace procedure t25140_out (a OUT int) as begin a := 7; end;
create or replace procedure t25140_inout (a INOUT int) as begin a := nvl (a, -1) + 100; end;
create or replace procedure t25140_out2 (a IN int, b OUT int) as begin b := a * 2; end;
create or replace function t25140_fout (a OUT int) return int as begin a := 7; return 1; end;

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

-- a ? of a prepared CALL
prepare st25140 from 'call t25140_out(?)';
execute st25140 using 5;
deallocate prepare st25140;

-- a function with an OUT parameter in an expression fails with the existing error
select t25140_fout (:h25140) from db_root;

drop procedure t25140_out;
drop procedure t25140_inout;
drop procedure t25140_out2;
drop function t25140_fout;

--+ server-message off
