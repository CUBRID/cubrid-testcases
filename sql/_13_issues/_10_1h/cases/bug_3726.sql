create class xoo ( a int unique, b clob);
insert into xoo values(1, char_to_clob('x'));
insert into xoo values(1, char_to_clob('y')), (2,char_to_clob('z'));

select clob_to_char(b) from xoo;

delete from xoo;
drop table xoo;
