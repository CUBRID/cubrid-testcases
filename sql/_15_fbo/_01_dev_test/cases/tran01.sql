autocommit off;
create class z (a int, b clob, c string);
insert into z values (1, char_to_clob('tran_commit'), 'tran1');
commit;
insert into z values (2, char_to_clob('tran_rollback'), 'tran1');
insert into z values (3, char_to_clob('tran_rollback'), 'tran1');
rollback;
select clob_to_char(b) from z;

delete from z;
drop z;
commit;
autocommit on;
