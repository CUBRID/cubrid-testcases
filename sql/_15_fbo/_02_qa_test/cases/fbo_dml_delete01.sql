create table del_t1 (nr int primary key not null auto_increment, b blob, c clob, str varchar(10) );
insert into del_t1 values (null, bit_to_blob(X'10011'),char_to_clob('aaa'),'ABC');
insert into del_t1 values (null, bit_to_blob(X'10111'),char_to_clob('bbb'),'BCD');
insert into del_t1 values (null, bit_to_blob(X'11011'),char_to_clob('ccc'),'CDE');

--1 delete ALL data WITHOUT any conditions.
select count(1) from del_t1;
delete from del_t1;
select count(1) from del_t1;
--2 delete TWO TIMES using without any conditions.
delete from del_t1;
select count(1) from del_t1;

--3 delete using IN clause.
insert into del_t1 values (null, bit_to_blob(X'10011'),char_to_clob('aaa'),'ABC');
insert into del_t1 values (null, bit_to_blob(X'10111'),char_to_clob('bbb'),'BCD');
insert into del_t1 values (null, bit_to_blob(X'11011'),char_to_clob('ccc'),'CDE');
select count(1) from del_t1;
delete from del_t1 where b in (bit_to_blob(X'10111'),bit_to_blob(X'10011'),bit_to_blob(X'11011'),bit_to_blob(X'11011'),bit_to_blob(X'11111'));
delete from del_t1 where blob_to_bit(b) in (X'10111',X'10011',X'11011',X'11011',X'11111');

--4 delete using SUBQUERY in where clause.
insert into del_t1 values (null, bit_to_blob(X'10011'),char_to_clob('aaa'),'ABC');
insert into del_t1 values (null, bit_to_blob(X'10111'),char_to_clob('bbb'),'BCD');
insert into del_t1 values (null, bit_to_blob(X'11011'),char_to_clob('ccc'),'CDE');
select count(1) from del_t1;
delete from del_t1 where blob_to_bit(b) = ( select blob_to_bit(b) from del_t1 as t2 where clob_to_char(t2.c) = clob_to_char(char_to_clob('aaa')));
select count(1) from del_t1;
delete from del_t1 where clob_to_char(c) = ( select clob_to_char(c) from del_t1 as t2 where blob_to_bit(t2.b) = blob_to_bit(bit_to_blob(X'11011')));
select count(1) from del_t1;

delete from del_t1;
drop table del_t1;