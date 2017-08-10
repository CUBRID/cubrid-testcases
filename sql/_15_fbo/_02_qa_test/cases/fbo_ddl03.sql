-- need change case and answer.
create table rt1 (nr int primary key not null auto_increment, b blob, c clob, str varchar(10) );
insert into rt1 values (null, bit_to_blob(X'10011'),char_to_clob('aaa'),'ABC');
insert into rt1 values (null, bit_to_blob(X'10111'),char_to_clob('bbb'),'BCD');
insert into rt1 values (null, bit_to_blob(X'11011'),char_to_clob('ccc'),'CDE');

--1 R30 CREATE table from a select clause.
create table rt2 as select * from rt1;
select nr, blob_to_bit(b),clob_to_char(c) str from rt2 order by nr;

insert into rt2 select * from rt1;
insert into rt1 select * from rt2;
select nr, blob_to_bit(b),clob_to_char(c) str from rt1 order by nr;
select nr, blob_to_bit(b),clob_to_char(c) str from rt2 order by nr;

delete from rt2;
drop rt2;

--2 R30	limit
select nr, blob_to_bit(b),clob_to_char(c) str from rt1 order by nr limit 2,5;
select nr, blob_to_bit(b),clob_to_char(c) str from rt1 order by nr limit 0,15;


--3 R30 TRUNCATE table
select nr,blob_to_bit(b),clob_to_char(c),str from rt1 order by nr;
truncate rt1;
select nr,blob_to_bit(b),clob_to_char(c),str from rt1 order by nr;

delete from rt1;
drop rt1;
