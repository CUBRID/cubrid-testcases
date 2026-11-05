--+ server-message on
-- error: a rejected CALL in a transaction, and a user other than DBA (CBRD-25140)
-- The rejected CALL does not undo the statements before it. Another user gets the same error.

drop table if exists t25140_tt;
create table t25140_tt (a int);
create or replace procedure t25140_out (a OUT int) as begin a := 7; end;

autocommit off;
insert into t25140_tt values (10);
call t25140_out (77);
commit;
autocommit on;
select a from t25140_tt order by a;

create user u25140;
grant execute on procedure t25140_out to u25140;
call login ('u25140', '') on class db_user;
call dba.t25140_out (77);
call login ('dba', '') on class db_user;
drop user u25140;

drop table t25140_tt;
drop procedure t25140_out;

--+ server-message off
