--+ server-message on
-- error: a prepared CALL with a constant for an IN OUT parameter fails on every execution (CBRD-25140)
-- Before, the procedure ran and the second execution took the value of the first one as its input.

drop table if exists t25140_log;
create table t25140_log (seq int auto_increment primary key, tag varchar(20), v int);
create or replace procedure t25140_inlog (a INOUT int) as begin insert into t25140_log (tag, v) values ('in', a); a := a + 100; end;

prepare st25140 from 'call t25140_inlog(5)';
execute st25140;
execute st25140;
deallocate prepare st25140;
select tag, v from t25140_log order by seq;

drop procedure t25140_inlog;
drop table t25140_log;

--+ server-message off
