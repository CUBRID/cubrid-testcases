--+ server-message on
-- error: a CALL action of a trigger with a constant or a correlation name for an OUT parameter (CBRD-25140)
-- The trigger is refused when it is created, so the statement that would fire it succeeds.
-- This holds for BEFORE, AFTER, STATEMENT and DEFERRED triggers.

drop table if exists t25140_tt;
create table t25140_tt (a int);
create or replace procedure t25140_out (a OUT int) as begin a := 7; end;

create trigger t25140_trg_c after insert on t25140_tt execute call t25140_out (5);
insert into t25140_tt values (1);
select count (*) from t25140_tt;

create trigger t25140_trg_o after insert on t25140_tt execute call t25140_out (obj.a);
insert into t25140_tt values (2);
select count (*) from t25140_tt;

create trigger t25140_trg_n before insert on t25140_tt execute call t25140_out (new.a);
insert into t25140_tt values (3);
select count (*) from t25140_tt;

create trigger t25140_trg_s after statement insert on t25140_tt execute call t25140_out (5);
insert into t25140_tt values (4);
select count (*) from t25140_tt;

create trigger t25140_trg_d after insert on t25140_tt execute deferred call t25140_out (5);
autocommit off;
insert into t25140_tt values (5);
commit;
rollback;
autocommit on;
select count (*) from t25140_tt;

drop table t25140_tt;
drop procedure t25140_out;

--+ server-message off
